/*
 Walter Vieira (2022-04-22)
 Sistemas de Informa��o - projeto JPAAulas_ex3
 C�digo desenvolvido para iulustra��o dos conceitos sobre acesso a dados, concretizados com base na especifica��o JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE vers�o 2022-03 (4.23.0).
 
N�o existe a pretens�o de que o c�digo estaja completo.

Embora tenha sido colocado um esfor�o significativo na corre��o do c�digo, n�o h� garantias de que ele n�o contenha erros que possam 
acarretar problemas v�rios, em particular, no que respeita � consist�ncia dos dados.  
 
*/

package presentation;

import java.util.List;
import java.util.Scanner;
import java.util.Set;

import businessLogic.*;

import java.util.ArrayList;


import model.*;


/**
 * Hello world!
 *
 */

public class App 
{
	protected interface ITest {
		void test();
	}
	
   @SuppressWarnings("unchecked")
	public static void main( String[] args ) throws Exception
   {   BLService srv = new BLService();
	   System.out.println(System.getenv("SI_DB_HOST"));
	   System.out.println(System.getenv("SI_DB_NAME"));
	   System.out.println(System.getenv("SI_DB_USER"));
	   System.out.println(System.getenv("SI_DB_PW"));

   	ITest tests[] = new ITest[] {
         () -> {try { srv.test1(); } catch(Exception e) {}}
         , () -> {try { srv.test2(); } catch(Exception e) { e.printStackTrace();}}
      };
   	
   	Scanner imp = new Scanner(System.in );
   	System.out.printf("Escolha um teste (1-%d)? ",tests.length);
   	int option = imp.nextInt();
   	if (option >= 1 && option <= tests.length)
   		tests[--option].test();

   }
}
