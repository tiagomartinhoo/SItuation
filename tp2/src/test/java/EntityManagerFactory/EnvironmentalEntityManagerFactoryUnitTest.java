package EntityManagerFactory;


import static org.assertj.core.api.Assertions.assertThat;

import java.util.Collections;

import jakarta.persistence.EntityManagerFactory;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExternalResource;

import com.google.common.collect.ImmutableMap;
import EntityManagerFactory.EnvironmentalEntityManagerFactory.ClosableEntityManagerFactoryProperties;

/*
 * Adapted tests for use within our project
 * SOURCE: https://gist.github.com/baumato/3283f255b00094411110fc889be58aa5
 */

public class EnvironmentalEntityManagerFactoryUnitTest {

    private static final String PERSISTENCE_UNIT = "JPAEx";

    @Rule
    public EnvironmentalEntityManagerFactoryRule environment = new EnvironmentalEntityManagerFactoryRule();

    @Test
    public void shouldReplaceVariablesInPersistenceXml_whenCreatingEntityManagerFactory_givenEnvironmentVariables() {
        //Once defined the environmental variables, these 2 lines can be commented to show proper results with real env vars
        environment.put("SI_DB_HOST", "localhost");
        environment.put("SI_DB_NAME", "SI");
        EntityManagerFactory factory = EnvironmentalEntityManagerFactory
                .createEntityManagerFactory(PERSISTENCE_UNIT, Collections.emptyMap());
        try (ClosableEntityManagerFactoryProperties closebleFactory = new ClosableEntityManagerFactoryProperties(factory)) {
            String jdbcUrl = String.valueOf(factory.getProperties().get("jakarta.persistence.jdbc.url"));
            assertThat(jdbcUrl).contains("jdbc:postgresql://localhost:5432/SI");
        }
    }

    @Test
    public void shouldSupportPropertiesFromOutside_whenCreatingEntityManagerFactory_givenPropertiesFromOutside() {
        Object value = new Object();
        EntityManagerFactory factory = EnvironmentalEntityManagerFactory
                .createEntityManagerFactory(PERSISTENCE_UNIT, ImmutableMap.of("KEY", value));
        try (ClosableEntityManagerFactoryProperties closebleFactory = new ClosableEntityManagerFactoryProperties(factory)) {
            Object actual = factory.getProperties().get("KEY");
            assertThat(actual).isEqualTo(value);
        }
    }

    @Test
    public void shouldSupportMultipleVariablesInOneProperty_whenCreatingEntityManagerFactory_givenPersistenceXmlPropertyWithMultipleVariables() {
        environment.put("SI_DB_HOST", "localhost");
        environment.put("SI_DB_NAME", "SI");
        EntityManagerFactory factory = EnvironmentalEntityManagerFactory
                .createEntityManagerFactory(PERSISTENCE_UNIT, Collections.emptyMap());
        try (ClosableEntityManagerFactoryProperties closebleFactory = new ClosableEntityManagerFactoryProperties(factory)) {
            String actual = String.valueOf(factory.getProperties().get("jakarta.persistence.jdbc.url"));
            assertThat(actual).isEqualTo("jdbc:postgresql://localhost:5432/SI");
        }
    }

    private static class EnvironmentalEntityManagerFactoryRule extends ExternalResource {

        @Override
        protected void before() throws Throwable {
        }

        void put(String key, String value) {
            EnvironmentalEntityManagerFactory.setEnvironmentVariables(ImmutableMap.of(key, value));
        }

        @Override
        protected void after() {
            EnvironmentalEntityManagerFactory.resetEnvironmentVariables();
        };
    }

}
