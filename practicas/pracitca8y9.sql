/*Practica 8*/
/*last_insert_id()*/
/*3) Como resultado de una mudanza a otro edificio más grande se ha incrementado la capacidad de los salones, además la experiencia que han adquirido los instructores permite ampliar el cupo de los cursos. Para todos los curso con modalidad presencial y semipresencial aumentar el cupo de la siguiente forma:
50% para los cursos con cupo menor a 20 
25% para los cursos con cupo mayor o igual a 20
*/

begin; 
update cursos set cupo = (
select (cur.cupo * 1.25 )
from cursos cur 
inner join plan_capacitacion pc on pc.nom_plan = cur.nom_plan
where (pc.modalidad = "Presencial" or pc.modalidad = "Semipresencial" ) and cur.cupo >= 20 ) ;


begin; 
update cursos set(cupo)
select (cur.cupo * 1.50 )
from cursos cur 
inner join plan_capacitacion pc on pc.nom_plan = cur.nom_plan
where (pc.modalidad = "Presencial" or pc.modalidad = "Semipresencial" ) and cur.cupo < 20  ;

begin; 
update cursos set cupo = cur.cupo * 1.25 where cur.cupo >= 20 and salon is not null ;
commit;
begin; 
update cursos set cupo = cur.cupo * 1.25 where cur.cupo < 20 and salon is not null;



/*4)Convertir a Daniel Tapia en el supervisor de Henri Amiel y Franz Kafka. Utilizar el cuil de cada uno.*/

select cuil into @supervisor 
from instructores where nombre = "Daniel" and apellido = "Tapia";
select cuil into @instructor1
from instructores where nombre = "Daniel" and apellido = "Tapia";
select cuil into @instructor2  
from instructores where nombre = "Daniel" and apellido = "Tapia";
begin ; 

update instructores set cuil_supervisor = @supervisor where cuil = @instructor2  or cuil = @instructor1;
commit;

















