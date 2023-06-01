create or replace procedure init()
language plpgsql
as 
$$
begin 
drop table if exists ensina cascade;
drop table if exists professores cascade;
drop table if exists hobbies cascade;
drop table if exists cacifos cascade; 
drop table if exists Eventos cascade;
drop table if exists inscr cascade;
drop table if exists alunos cascade; 
drop table if exists disciplinas cascade;


--create table cacifos(numCac serial  primary key, descrCac varchar(80));
create table cacifos(
        numCac int generated always as identity primary key,
        descrCac varchar(80)
        );
             --aluga_al numeric(6) unique references alunos);   
create table alunos(
        numAl numeric(6) primary key,
        nomeAl varchar(80),
        aluga_cac int unique references cacifos
        );
                   
                
create table hobbies(numAl numeric(6) references alunos, numHb int, descr varchar(100), 
             primary key(numAl,numHb)); 

--alter table alunos add constraint c foreign key(aluga_cac) references cacifos; 
create table disciplinas(codDisc char(6) primary key, descrDisc varchar(80));
create table inscr(numAl numeric(6) references alunos,
                   codDisc char(6) references disciplinas,
                   nota integer check (nota between 0 and 20),
                   primary key(numAl,CodDisc));
				   
-- Os eventos são numerados sequencialmente em todo o sistema				   
--create table Eventos(idEv serial primary key, descrEv varchar(80),
create table Eventos(idEv int generated always as identity primary key, descrEv varchar(80),
                     numAl numeric(6), codDisc char(6),
                     foreign key(numAl,codDisc) references inscr);
CREATE TABLE public.professores (
	numprof numeric(5) PRIMARY KEY,
	nomeprof varchar(80)
	);
CREATE TABLE public.ensina (
	numprof numeric(5) references professores,
	coddisc bpchar(6) references disciplinas,
    PRIMARY KEY (numprof, coddisc)
);


insert into disciplinas values
('isi', 'Intr. Sist. Inf.'),
('sisinf', 'Sistemas de Inf.'),
('lc', 'Lógica e Computação');


insert into cacifos(descrCac) values
('cacifo 1'),
('cacifo 2'),
('cacifo 3'),
('cacifo 1'); -- para teste

insert into alunos values
(111,'rui', 1),
(222,'ana',null),
(333,'paula',3);

insert into inscr values
(111,'isi',13),
(222,'lc', 16),
(111,'lc',12),
(111,'sisinf',12);


insert into professores values
(111,'prof x'),
(222, 'prof y'),
(333, 'prof z');

insert into hobbies values
(111,1,'h1'),
(111,2,'h2');


insert into ensina values
(111,'isi'),
(111,'lc');

end; $$;

call init();

select * from ensina;
---------------------------------------------

update alunos set aluga_cac = 1 where numal = 111;

select * from alunos for share;
select * from cacifos;
select * from Hobbies;


select * from eventos;


select * from inscr;




delete from hobbies;
delete from alunos ;
delete from cacifos;

select * from inscr;





select * from contas;

--------------------------------------------------
drop function if exists fescalar;

create or replace function fescalar( p1 in int, p2 out int ) returns int
as $$
declare
begin
   p2 = p1*2;
end;
$$ language plpgsql

--Ou:
create or replace function fescalar( p1 in int) returns int
as $$
declare
begin
   return p1+p1;
end;
$$ language plpgsql

drop table if exists t;
create table t(i int primary key);
insert into t values
(1),(2),(4),(8);

drop function if exists frefcursor;
create or replace function frefcursor(n int) returns refcursor
language plpgsql as 
$$
declare c refcursor;
begin
  open c for select i from t where i > n;
  return c;
end;
$$;

drop procedure prefcursor
create or replace procedure prefcursor(p1 int, r out refcursor) 
language plpgsql as 
$$

begin
  open r for select i from t where i > n;

end;
$$;



drop table if exists t;
create table t(i int primary key, j int);
insert into t values
(1,11),(2,22),(4,44),(8,88);

create function ftabela(i int) 
returns table (a int, b int)
language plpgsql as 
$$
begin
  return query select  t.i,t.j from t where t.i > $1;
end;
$$;
 
delete from t;
drop procedure if exists sp;
create or replace procedure sp (p1 in int)--, p2 out int )
as $$
declare
begin
	
   --select j into p2 from t where i = p1;
  insert into t values(p1+10000,p1+10000);
 --commit; -- o comportamento com chamada via JPA é diferente de com chsmsda em Sql
end;
$$ language plpgsql

begin;
call sp(1);
commit;


select * from t;
do
$$
declare v int;
begin
call sp(1,v);
raise notice 'xx%',v;
end;
$$ language plpgsql;



select * from alunos where numal = 111 for update;


-------------------------------

drop table if exists contas cascade;
create table contas (Id numeric(5) primary key, 
                     saldo real not null check (saldo >= 0));
                    
insert into contas values
(1111,1000),
(2222,1000),
(3333,1000);


 update contas set saldo = saldo - 600 where id = 1111 and saldo >= 600;
 
select * from contas;


--------------optimistic locking ------------------
drop table if exists contasOpt cascade;
create table contasOpt (Id numeric(5) primary key, vers int,
                        saldo real not null check (saldo >= 0));

create or replace function f_opt_lock() returns trigger 
language plpgsql
as $$
declare c int;
begin  

	if new.vers is null then
	   new.vers = 0;
	elseif new.vers = old.vers then
        new.vers = new.vers + 1;
    end if;
    return new; 
end; $$;
 
 
 CREATE or replace TRIGGER GL_Opt 
BEFORE insert or UPDATE on contasOpt
FOR EACH ROW
   execute function f_opt_lock();       
  
  
insert into contasOpt(Id,saldo) values
(1111,1000),
(2222,1000),
(3333,1000);


update contasOpt set saldo = saldo - 600 where id = 1111 and saldo >= 600;
 

select * from  contasOpt;



select * from alunos;

delete from alunos where numal > 1000



