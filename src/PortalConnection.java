
import java.sql.*; // JDBC stuff.
import java.util.Properties;

public class PortalConnection {

    // Set this to e.g. "portal" if you have created a database named portal
    // Leave it blank to use the default database of your database user
    static final String DBNAME = "lab1";
    // For connecting to the portal database on your local machine
    static final String DATABASE = "jdbc:postgresql://localhost/"+DBNAME;
    static final String USERNAME = "postgres";
    static final String PASSWORD = "postgres";

    // For connecting to the chalmers database server (from inside chalmers)
    // static final String DATABASE = "jdbc:postgresql://brage.ita.chalmers.se/";
    // static final String USERNAME = "tda357_nnn";
    // static final String PASSWORD = "yourPasswordGoesHere";


    // This is the JDBC connection object you will be using in your methods.
    private Connection conn;

    public PortalConnection() throws SQLException, ClassNotFoundException {
        this(DATABASE, USERNAME, PASSWORD);  
    }

    // Initializes the connection, no need to change anything here
    public PortalConnection(String db, String user, String pwd) throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user", user);
        props.setProperty("password", pwd);
        conn = DriverManager.getConnection(db, props);
    }


    // Register a student on a course, returns a tiny JSON document (as a String)
    public String register(String student, String courseCode){
        try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO Registrations VALUES(?, ?)");){

                pstmt.setString(1, student);
                pstmt.setString(2, courseCode);




            int rs = pstmt.executeUpdate();

            if(rs > 0){
                System.out.println("INSERTED " + student + " TO " + courseCode + " IN Registrations.");
                pstmt.close();
                return "{\"success\":true}";
            }
            else
                return "{\"student\":false, \"error\":\"does not exist\"}";

        } catch (SQLException e){
            return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
        }
    }

    // Unregister a student from a course, returns a tiny JSON document (as a String)
    public String unregister(String student, String courseCode) {

        try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Registrations r " +
                "WHERE r.student = ? AND r.course = ?");){

                pstmt.setString(1, student);
                pstmt.setString(2, courseCode);

                int r = pstmt.executeUpdate();
                if (r == 0){
                    return "{\"success\":false, \"error\":\"" + "Couldn't find student as registered or waiting" + "\"}";
                }
                else{
                    System.out.println("DELETED " + student + " FROM " + courseCode + " IN Registrations.");
                    pstmt.close();
                    return "{\"success\":true}";
                }

/*
            ResultSet rs = pstmt.executeQuery();

            if(rs.next()){
                System.out.println("DELETED " + student + " FROM " + courseCode + " IN Registrations.");
                pstmt.close();
                return "{\"success\":True}";
                return rs.getString("jsondata");
            }
            else
                return "{\"student\":\"does not exist :(\"}";


 */
        } catch (SQLException e) {
            return "{\"success\":false, \"error\":\"" + getError(e) + "\"}";
        }
    }


    // Return a JSON document containing lots of information about a student, it should validate against the schema found in information_schema.json
    public String getInfo(String student) throws SQLException{
        try(PreparedStatement st = conn.prepareStatement(
                "WITH CourseAndName AS \n" +
                        "(SELECT code, name FROM Courses),\n" +
                        "FinishedCoursesAgg AS\n" +
                        "(SELECT f.student,\n" +
                        "       json_agg(\n" +
                        "        json_build_object(\n" +
                        "        'course', cn.name,\n" +
                        "        'code', cn.code,\n" +
                        "        'credits', credits,\n" +
                        "        'grade', grade\n" +
                        "            ))\n" +
                        "        AS courses\n" +
                        "        FROM FinishedCourses f\n" +
                        "        JOIN CourseAndName cn \n" +
                        "        ON f.course = cn.code\n" +
                        "        GROUP BY f.student\n" +
                        "        ORDER BY f.student\n" +
                        "    ),\n" +
                        "RegisteredCoursesAgg AS \n" +
                        "(SELECT r.student,\n" +
                        "        json_agg(\n" +
                        "        json_build_object(\n" +
                        "        'course', cn.name,\n" +
                        "        'code', cn.code,\n" +
                        "        'status', r.status,\n" +
                        "        'position', CASE\n" +
                        "                        WHEN r.status = 'registered' THEN 0\n" +
                        "                        WHEN r.status = 'waiting' THEN c.place\n" +
                        "                    END\n" +
                        "                    ))\n" +
                        "        AS courses\n" +
                        "        FROM Registrations r \n" +
                        "        LEFT JOIN CourseQueuePositions c \n" +
                        "        ON r.course = c.course\n" +
                        "        AND r.student = c.student\n" +
                        "        JOIN CourseAndName cn ON r.course = cn.code\n" +
                        "        GROUP BY r.student\n" +
                        "        ORDER BY r.student\n" +
                        "    )\n" +
                        "SELECT DISTINCT ON (si.student)\n" +
                        "    json_build_object(\n" +
                        "        'student', si.student,\n" +
                        "        'name', si.name,\n" +
                        "        'login', si.login,\n" +
                        "        'program', si.program,\n" +
                        "        'branch', si.branch,\n" +
                        "        'finished', COALESCE(fc.courses, '[]' :: json),\n" +
                        "        'registered', COALESCE(rc.courses, '[]' :: json),\n" +
                        "        'seminarCourses', si.seminarCoursePass,\n" +
                        "        'mathCredits', si.mathCredits,\n" +
                        "        'researchCredits', si.researchCredits,\n" +
                        "        'totalCredits', si.totalCredits,\n" +
                        "        'canGraduate', si.canGraduate\n" +
                        "    )\n" +
                        "AS jsondata FROM studentInformation si \n" +
                        "LEFT JOIN FinishedCoursesAgg fc ON si.student = fc.student\n" +
                        "LEFT JOIN RegisteredCoursesAgg rc ON si.student = rc.student\n" +
                        "WHERE si.student = ?\n" +
                        "ORDER BY si.student \n");){
            st.setString(1, student);

            ResultSet rs = st.executeQuery();

            if(rs.next())
                return rs.getString("jsondata");
            else
                return "{\"student\":\"does not exist :(\"}";
        }
        /*
        try(PreparedStatement st = conn.prepareStatement(

            // replace this with something more useful
            "SELECT jsonb_build_object('student',idnr,'name',name) AS jsondata FROM BasicInformation WHERE idnr=?"
            );){

            st.setString(1, student);

            ResultSet rs = st.executeQuery();

            if(rs.next())
              return rs.getString("jsondata");
            else
              return "{\"student\":\"does not exist :(\"}";

        }

         */
    }

    // This is a hack to turn an SQLException into a JSON string error message. No need to change.
    public static String getError(SQLException e){
       String message = e.getMessage();
       int ix = message.indexOf('\n');
       if (ix > 0) message = message.substring(0, ix);
       message = message.replace("\"","\\\"");
       return message;
    }
}