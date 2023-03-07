public class TestPortal {

   // enable this to make pretty printing a bit more compact
   private static final boolean COMPACT_OBJECTS = false;

   // This class creates a portal connection and runs a few operation

   public static void main(String[] args) {
      try{
         PortalConnection c = new PortalConnection();
   
         // Write your tests here. Add/remove calls to pause() as desired. 
         // Use println instead of prettyPrint to get more compact output (if your raw JSON is already readable)

          //List info for a student.

          System.out.println((c.getInfo("5555555555")));
          pause();

          //Register a student for an unrestricted course, and check that he/she ends up registered (print info again).
          // Should pass
          System.out.println(c.register("7777777777", "CCC555"));
          System.out.println((c.getInfo("7777777777")));
          pause();

          //Register the same student for the same course again, and check that you get an error response.

          // Should fail
          System.out.println(c.register("7777777777", "CCC555"));
          pause();

          //Unregister the student from the course, and then unregister him/her again from the same course.
          //Check that the student is no longer registered and that the second unregistration gives an error response.

          System.out.println(c.unregister("7777777777", "CCC555"));
          System.out.println((c.getInfo("7777777777")));
          //should pass
          pause();

          System.out.println(c.unregister("7777777777", "CCC555"));
          // Should fail.
          pause();


          //Register the student for a course that he/she does not have the prerequisites for, and check that an error is generated.

          System.out.println(c.register("7777777777", "CCC123"));
          //Should fail.
          pause();


          //Unregister a student from a restricted course that he/she is registered to, and which has at least two students in the queue.
          System.out.println(c.getInfo("5555555555"));
          System.out.println(c.unregister("5555555555", "CCC999"));
          pause();

          //Register the student again to the same course and check that the student gets the correct (last) position in the waiting list.

          System.out.println(c.getInfo("5555555555"));
          System.out.println(c.register("5555555555", "CCC999"));
          System.out.println(c.getInfo("5555555555"));
          pause();


          //Unregister and re-register the same student for the same restricted course, and check that the student is first removed and then ends up in the same position as before (last).
          System.out.println(c.getInfo("6666666666"));
          System.out.println(c.unregister("6666666666", "CCC000"));
          System.out.println(c.getInfo("6666666666"));
          pause();

          System.out.println(c.register("6666666666", "CCC000"));
          System.out.println(c.getInfo("6666666666"));
          pause();

          //Unregister a student from an overfull course, i.e. one with more students registered than there are places on the course (you need to set this situation up in the database directly).
          //Check that no student was moved from the queue to being registered as a result.

          System.out.println(c.getInfo("4444444444"));
          System.out.println(c.getInfo("5555555555"));
          System.out.println(c.getInfo("6666666666"));

          System.out.println(c.unregister("4444444444", "CCC456"));
          System.out.println(c.getInfo("6666666666"));
          pause();

          //Unregister with the SQL injection you introduced, causing all (or almost all?) registrations to disappear.
          System.out.println(c.getInfo("1111111111"));
          System.out.println(c.getInfo("2222222222"));
          System.out.println(c.getInfo("3333333333"));
          System.out.println(c.getInfo("4444444444"));
          System.out.println(c.getInfo("5555555555"));
          System.out.println(c.getInfo("6666666666"));
          System.out.println(c.getInfo("7777777777"));

          System.out.println(c.unregister("4444444444", "x' OR '1'='1" ));

          System.out.println(c.getInfo("1111111111"));
          System.out.println(c.getInfo("2222222222"));
          System.out.println(c.getInfo("3333333333"));
          System.out.println(c.getInfo("4444444444"));
          System.out.println(c.getInfo("5555555555"));
          System.out.println(c.getInfo("6666666666"));
          System.out.println(c.getInfo("7777777777"));




          
      } catch (ClassNotFoundException e) {
         System.err.println("ERROR!\nYou do not have the Postgres JDBC driver (e.g. postgresql-42.5.1.jar) in your runtime classpath!");
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   
   
   public static void pause() throws Exception{
     System.out.println("PRESS ENTER");
     while(System.in.read() != '\n');
   }
   
   // This is a truly horrible and bug-riddled hack for printing JSON. 
   // It is used only to avoid relying on additional libraries.
   // If you are a student, please avert your eyes.
   public static void prettyPrint(String json){
      System.out.print("Raw JSON:");
      System.out.println(json);
      System.out.println("Pretty-printed (possibly broken):");
      
      int indent = 0;
      json = json.replaceAll("\\r?\\n", " ");
      json = json.replaceAll(" +", " "); // This might change JSON string values :(
      json = json.replaceAll(" *, *", ","); // So can this
      
      for(char c : json.toCharArray()){
        if (c == '}' || c == ']') {
          indent -= 2;
          breakline(indent); // This will break string values with } and ]
        }
        
        System.out.print(c);
        
        if (c == '[' || c == '{') {
          indent += 2;
          breakline(indent);
        } else if (c == ',' && !COMPACT_OBJECTS) 
           breakline(indent);
      }
      
      System.out.println();
   }
   
   public static void breakline(int indent){
     System.out.println();
     for(int i = 0; i < indent; i++)
       System.out.print(" ");
   }   
}
