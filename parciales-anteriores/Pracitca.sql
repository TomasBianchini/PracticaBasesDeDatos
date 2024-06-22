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
update cursos cur
inner join plan_capacitacion pc on pc.nom_plan = cur.nom_plan
 set cur.cupo = cur.cupo * 1.50
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

/*Practica 9 */
/*INSERT SELECT
Crear una nueva lista de precios para todos los planes de capacitación, a partir del 01/06/2009 con un 20 por ciento más que su último valor. Eliminar las filas agregadas.
*/

create temporary table fechas

select nom_plan, max(fecha_desde_plan) as fecha
from valores_plan
group by nom_plan;



begin ;

insert into valores_plan (nom_plan, fecha_desde_plan, valor_plan)
select va.nom_plan, '2023-10-18', va.valor_plan*1.20 
from valores_plan va 
inner join fechas fe on fe.nom_plan = va.nom_plan and fe.fecha = va.fecha_desde_plan;

commit ;


call alumno_inscripcion(24242424, 'Marketing 1' , 1);















