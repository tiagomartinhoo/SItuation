package entityManagerFactory;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.spi.PersistenceUnitInfo;

import org.eclipse.persistence.internal.jpa.EntityManagerFactoryDelegate;
import org.eclipse.persistence.internal.jpa.EntityManagerFactoryImpl;

import com.google.common.collect.Maps;

/**
 * Use this class instead of
 *
 * <pre>
 * <code>
 * 	EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory(puName);
 * 	EntityManager em = entityManagerFactory.createEntityManager();
 * </code>
 * </pre>
 *
 * because this class allows to override properties using environment variables. Usage in persistence.xml:
 *
 * <pre>
 * <code>
 * 	<property name="javax.persistence.jdbc.url"
 *    value="jdbc:db2://${DEVE_DB_HOST}/DB:currentSchema=DEVELOP;" />
 * 	<property name="javax.persistence.jdbc.user" value="${DEVE_DB_USER}" />
 * 	<property name="javax.persistence.jdbc.password" value="${DEVE_DB_PASSWORD}" />
 * </code>
 * </pre>
 *
 */

// Source: https://gist.github.com/baumato/3283f255b00094411110fc889be58aa5

public class EnvironmentalEntityManagerFactory {

    private static final Map<String, String> ENVIRONMENT = new HashMap<>(System.getenv());

    public static void setEnvironmentVariables(Map<String, String> environment) {
        ENVIRONMENT.putAll(environment);
    }

    public static void resetEnvironmentVariables() {
        ENVIRONMENT.clear();
        ENVIRONMENT.putAll(System.getenv());
    }

    public static EntityManager createEntityManager(String persistenceUnitName) {
        return createEntityManager(persistenceUnitName, Collections.emptyMap());
    }

    public static EntityManager createEntityManager(
            String persistenceUnitName,
            Map<Object, Object> entityManagerFactoryProperties) {
        return createEntityManagerFactory(persistenceUnitName, entityManagerFactoryProperties).createEntityManager();
    }

    public static EntityManagerFactory createEntityManagerFactory(String persistenceUnitName) {
       return createEntityManagerFactory(persistenceUnitName, Collections.emptyMap());
    }

    public static EntityManagerFactory createEntityManagerFactory(
            String persistenceUnitName,
            Map<Object, Object> properties) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory(persistenceUnitName);
        try (ClosableEntityManagerFactoryProperties factoryProps = new ClosableEntityManagerFactoryProperties(factory)) {
            Map<Object, Object> overrideProps = replaceWithEnvironmentVariableValues(factoryProps.asMap());
            overrideProps.putAll(properties);
            return Persistence.createEntityManagerFactory(persistenceUnitName, overrideProps);
        }
    }

    private static Map<Object, Object> replaceWithEnvironmentVariableValues(Map<String, String> props) {
        Map<Object, Object> overrideProps = new HashMap<>();
        for (Entry<String, String> entry : props.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            boolean overridden = false;
            if (containsVariable(key)) {
                key = replaceWithVariableValue(key);
                overridden = true;
            }
            if (containsVariable(value)) {
                value = replaceWithVariableValue(value);
                overridden = true;
            }
            if (overridden) {
                overrideProps.put(key, value);
            }
        }
        return overrideProps;
    }

    private static boolean containsVariable(String s) {
        int variableStartIndex = s.indexOf("${");
        int variableEndIndex = s.lastIndexOf('}');
        return variableStartIndex >= 0 && variableStartIndex < variableEndIndex;
    }

    private static String replaceWithVariableValue(String key) {
        for (Entry<String, String> entry : ENVIRONMENT.entrySet()) {
            key = key.replace("${" + entry.getKey() + "}", entry.getValue());
        }
        return key;
    }

    static final class ClosableEntityManagerFactoryProperties implements AutoCloseable {

        private final EntityManagerFactory factory;

        ClosableEntityManagerFactoryProperties(EntityManagerFactory factory) {
            this.factory = factory;
        }

        @Override
        public void close() {
            factory.close();
        }

        Map<String, String> asMap() {
            EntityManagerFactoryImpl eclipseLinkFactory = factory.unwrap(EntityManagerFactoryImpl.class);
            EntityManagerFactoryDelegate delegate = eclipseLinkFactory.unwrap(EntityManagerFactoryDelegate.class);
            PersistenceUnitInfo persistenceUnitInfo = delegate.getSetupImpl().getPersistenceUnitInfo();
            Properties factoryProps = persistenceUnitInfo.getProperties();
            return Maps.fromProperties(factoryProps);
        }
    }

}
