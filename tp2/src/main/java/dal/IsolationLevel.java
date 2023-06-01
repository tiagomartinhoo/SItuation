package dal;

import java.sql.Connection;

public class IsolationLevel {
    static public final int READ_UNCOMMITED = Connection.TRANSACTION_READ_UNCOMMITTED;
    static public final int READ_COMMITED = Connection.TRANSACTION_READ_COMMITTED;
    static public final int REPEATABLE_READ = Connection.TRANSACTION_REPEATABLE_READ;
    static public final int SERIALIZABLE = Connection.TRANSACTION_SERIALIZABLE;
}
