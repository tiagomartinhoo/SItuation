/*
 Walter Vieira (2022-04-22)
 Sistemas de Informa��o - projeto JPAAulas_ex6
 C�digo desenvolvido para iulustra��o dos conceitos sobre acesso a dados, concretizados com base na especifica��o JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE vers�o 2022-03 (4.23.0).
 
N�o existe a pretens�o de que o c�digo estaja completo.

Embora tenha sido colocado um esfor�o significativo na corre��o do c�digo, n�o h� garantias de que ele n�o contenha erros que possam 
acarretar problemas v�rios, em particular, no que respeita � consist�ncia dos dados.  
 
*/

package dal;

import jakarta.persistence.EntityManager;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public abstract class AbstractDataScope implements AutoCloseable {
	
	protected class Session {
		private EntityManagerFactory ef;//deveria ser um singleton
		private EntityManager em;
		private boolean ok = true;
	
	}
	
	boolean isMine = true;
	boolean voted = false;
	
	private static final ThreadLocal<Session> threadLocal = ThreadLocal.withInitial(() -> null);
	
	
	public AbstractDataScope() {
		if (threadLocal.get()==null) {
			EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAExemplo");
			EntityManager em = emf.createEntityManager();
	    	Session s = new Session();
	    	s.ef = emf;
	    	s.ok = true;
	    	s.em = em;
			threadLocal.set(s);
			em.getTransaction().begin();
			isMine = true;
		}
		else
			isMine = false;
	}
	
	

	//Para podermos usar diretamente JPA
	public EntityManager getEntityManager() {return threadLocal.get().em;}



	@Override
	public void close() throws Exception {
		// TODO Auto-generated method stub
		if (isMine) {
			if(threadLocal.get().ok && voted)  {
			threadLocal.get().em.getTransaction().commit();
		   }
	       else
	    	   threadLocal.get().em.getTransaction().rollback(); 	
		threadLocal.get().em.close();
		threadLocal.get().ef.close();
		threadLocal.remove();
		//ou:
		//threadLocal.set(null);
	  }
	  else
		  if (!voted)
			  cancelWork();
			  
   }
		
	
	public void validateWork() {
	  	  voted = true;
	}
	
	public void cancelWork() {
		threadLocal.get().ok = false;
		voted = true;
	}



}
