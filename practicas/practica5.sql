/*1 )¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?
*/

select distinct pers.dni, pers.nombre, pers.apellido
from personas pers
inner join contratos cons on cons.dni = pers.dni
where cons.cuit in(select emp.cuit
from empresas emp 
inner join contratos con on con.cuit = emp.cuit 
inner join personas per on per.dni = con.dni 
where per.nombre = "Stefania" and per.apellido = "Lopez");

/*2) Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados de Viejos Amigos. 
*/
select max(con.sueldo) into @max_sueldo_viejos_amigos
from contratos con 
inner join empresas emo on emo.cuit = con.cuit
where emo.razon_social ="Viejos Amigos"; 

select per.dni, per.nombre, con.sueldo
from contratos con 
inner join personas per on per.dni = con.dni
where con.sueldo < @max_sueldo_viejos_amigos; 

/*3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo de aquellas cuyo promedio supere al promedio de Tráigame eso.*/
select avg(com.importe_comision) into @promedio_comision
from comisiones com
inner join contratos con on con.nro_contrato = com.nro_contrato
inner join empresas emp on emp.cuit = con.cuit 
where emp.razon_social = 'Traigame eso'; 

select emp.cuit, emp.razon_social, avg(com.importe_comision) as prom
from empresas emp 
inner join contratos con on con.cuit = emp.cuit 
inner join comisiones com on com.nro_contrato = con.nro_contrato 
group by emp.cuit, emp.razon_social
having prom > @promedio_comision; 

/*
4)  Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes contrato, año contrato , nro. contrato, nombre y apellido del empleado.
*/
select avg(com.importe_comision) into @promedio_general_comision
from comisiones com
; 
select emp.cuit, emp.razon_social, per.nombre, per.apellido,con.nro_contrato, com.anio_contrato, com.mes_contrato,  
 avg(com.importe_comision) as prom
from empresas emp 
inner join contratos con on con.cuit = emp.cuit 
inner join comisiones com on com.nro_contrato = con.nro_contrato 
inner join personas per on per.dni = con.dni
group by emp.cuit, emp.razon_social, per.nombre, per.apellido,con.nro_contrato, com.anio_contrato, com.mes_contrato
having prom <  @promedio_general_comision;
 
/*
5) Determinar las empresas que pagaron en promedio la mayor de las comisiones. */
create temporary table promedioCom
 select emp.cuit, avg(com.importe_comision) as prom
from comisiones com
inner join contratos con on con.nro_contrato = com.nro_contrato
inner join empresas emp on emp.cuit = con.cuit 
group by emp.cuit;

select max(pc.prom) into @comision_maxima
from promedioCom pc ; 

select emp.razon_social, pc.prom
from empresas emp 
inner join promedioCom pc on pc.cuit = emp.cuit 
where pc.prom = @comision_maxima; 

/*
6) Seleccionar los empleados que no tengan educación no formal o terciario.*/

select per.dni, per.nombre, per.apellido
from personas per 
where per.dni not in(
select distinct per2.dni
from personas per2 
inner join personas_titulos pt on pt.dni = per2.dni
inner join titulos tit on tit.cod_titulo = pt.cod_titulo
where tit.tipo_titulo in ("Educacion no formal","Terciario")
);

/*7)  Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los contrató. */
create temporary table promedio_sueldo
select emp.cuit, avg(con.sueldo) as prom
from empresas emp 
inner join contratos con on emp.cuit = con.cuit 
group by emp.cuit;

select per.dni, per.nombre, per.apellido, con.sueldo, ps.prom
from personas per 
inner join contratos con on con.dni = per.dni 
inner join promedio_sueldo ps on ps.cuit = con.cuit 
where con.sueldo > ps.prom;

 /*8) Determinar las empresas que pagaron en promedio la mayor o menor de  las comisiones*/
drop table if exists comisiones_promedio; 

create temporary table comisiones_promedio
select con.cuit , avg(com.importe_comision) as promedio
from contratos con 
inner join comisiones com on com.nro_contrato = con.nro_contrato
group by 1;

select min(cp.promedio) into @comision_minima 
from comisiones_promedio cp;
select max(cp.promedio) into @comision_maxima
from comisiones_promedio cp;

select emp.razon_social, cp.promedio
from empresas emp
inner join comisiones_promedio cp on cp.cuit = emp.cuit
where cp.promedio = @comision_minima  or cp.promedio = @comision_maxima;

/*  AFATSE*/
/*9) Alumnos que se  hayan inscripto a más cursos que Antoine de Saint-Exupery. Mostrar todos los datos de los alumnos, la cantidad de cursos a la que se inscribió y cuantas veces más que Antoine de Saint-Exupery.*/

select count(*) into @cant_cursos_antoine 
from inscripciones ins 
inner join alumnos alu on alu.dni = ins.dni
where alu.nombre = "Antoine de" and alu.apellido = "Saint-Exupery"; 

select alu.*, count(*) cant_cursos, count(*)-@cant_cursos_antoine cant_mas_anatoine 
from alumnos alu
inner join inscripciones ins on ins.dni = alu.dni
group by alu.dni 
having cant_cursos > @cant_cursos_antoine;

/*10) En el año 2014, qué cantidad de alumnos se han inscripto a los Planes de Capacitación indicando para cada
 Plan de Capacitación la cantidad de alumnos inscriptos y el porcentaje que representa respecto del
 total de inscriptos a los Planes de Capacitación dictados en el año.*/
 
 select count(*) into @cant_inscripciones_2014
 from inscripciones  ins
 where year(ins.fecha_inscripcion) = 2014;
 
 select ins.nom_plan, count(*), count(*) / @cant_inscripciones_2014 *100 as "%Total"
 from inscripciones ins 
 where year(ins.fecha_inscripcion) = 2014
 group by 1; 
 
  /*11) Indicar el valor actual de los planes de Capacitación */
 with fecha_actuales as( select val.nom_plan, max(val.fecha_desde_plan) as ultima_fecha
 from valores_plan val
 group by 1)
select vp.nom_plan, vp.valor_plan
from valores_plan vp 
inner join fecha_actuales fa on fa.nom_plan =vp.nom_plan
where vp.fecha_desde_plan = ultima_fecha
; 
 

/*12) Plan de capacitacion mas barato. Indicar los datos del plan de capacitacion y el valor actual*/

drop table if exists fecha_valor_planes;
create temporary table  fecha_valor_planes 
select vp.nom_plan,  max(fecha_desde_plan) as fecha_desde
from valores_plan vp
group by 1;

create temporary table valor_plan
select fvp.nom_plan as nom_plan , fvp.fecha_desde as fecha_desde, vp.valor_plan as valor
from fecha_valor_planes fvp 
inner join valores_plan vp on fvp.nom_plan = vp.nom_plan
where fvp.fecha_desde = vp.fecha_desde_plan; 

select min(vp.valor_plan) into @precio_minimo
from valor_plan vp; 
select @precio_minimo;

select pc.nom_plan, pc.desc_plan, pc.hs, pc.modalidad, @precio_minimo
from plan_capacitacion pc
inner join valor_plan vp on vp.nom_plan = pc.nom_plan 
where vp.valor_plan = @precio_minimo;

/*13 ¿Qué instructores que han dictado algún curso del Plan de Capacitación “Marketing 1”
 el año 2014 y no vayan a dictarlo este año? (año 2015)*/

select distinct ins.cuil, ins.nombre
from instructores ins
inner join cursos_instructores ci on ci.cuil = ins.cuil
inner join cursos cur on cur.nom_plan = ci.nom_plan and cur.nro_curso = ci.nro_curso
where ci.nom_plan = "Marketing 1" and year(cur.fecha_ini) = 2014
and ins.cuil not in (
select ins2.cuil 
from instructores ins2
 inner join cursos_instructores ci2 on ci2.cuil = ins2.cuil
inner join cursos cur2 on cur2.nom_plan = ci2.nom_plan and cur2.nro_curso = ci2.nro_curso
where ci2.nom_plan = "Marketing 1" and year(cur2.fecha_ini) = 2015);

/*14)  Alumnos que tengan todas sus cuotas pagas hasta la fecha.*/

select alu.* 
from alumnos alu
where alu.dni not in (
select distinct cu.dni 
from cuotas cu 
where cu.fecha_emision <= curdate() and fecha_pago is null);


/*15) Alumnos cuyo promedio supere al del curso que realizan. Mostrar dni, nombre y apellido, promedio y promedio del curso.*/
with promedio_cursos as(
select cur.nom_plan, cur.nro_curso, avg(eva.nota) promedio_curso
from cursos cur 
inner join evaluaciones eva on eva.nom_plan = cur.nom_plan and eva.nro_curso= cur.nro_curso
group by cur.nom_plan, cur.nro_curso) 
select alu.dni, alu.nombre, alu.apellido, pc.nom_plan ,avg(eva.nota), pc.promedio_curso
from alumnos alu 
inner join evaluaciones eva on eva.dni = alu.dni
inner join promedio_cursos pc on  eva.nom_plan = pc.nom_plan and eva.nro_curso= pc.nro_curso
group by alu.dni, alu.nombre, alu.apellido, pc.nom_plan , pc.promedio_curso
having avg(eva.nota) > pc.promedio_curso;

/*16)Para conocer la disponibilidad de lugar en los cursos que empiezan en abril para lanzar una campaña  se desea conocer la cantidad de alumnos inscriptos a los cursos que comienzan a partir del 1/04/2014 indicando: Plan de Capacitación, curso, fecha de inicio, salón, cantidad de alumnos inscriptos y diferencia con el cupo de alumnos registrado para el curso que tengan al más del 80% de lugares disponibles respecto del cupo.
Ayuda: tener en cuenta el uso de los paréntesis y la precedencia de los operadores matemáticos.*/

select cur.nom_plan, cur.nro_curso, cur.salon, cur.fecha_ini, cur.cupo, count(*), cur.cupo - count(*)
from cursos cur 
inner join inscripciones ins on ins.nom_plan = cur.nom_plan and ins.nro_curso = cur.nro_curso
where cur.fecha_ini >= "2014-04-01" 
group by cur.nom_plan, cur.nro_curso, cur.salon, cur.fecha_ini
; 


/*17) Indicar el último incremento de los valores de los planes de capacitación, consignando nombre del plan fecha del valor actual, fecha del valor anterior, valor actual, valor anterior y diferencia entre los valores. Si el curso tiene un único valor mostrar la fecha anterior en NULL el valor anterior en 0 y la diferencia a 0.*/
drop table if exists valores_actuales; 

create temporary table valores_actuales
with fecha as(
select vp.nom_plan, max(vp.fecha_desde_plan) as fecha_actual
from valores_plan vp
group by vp.nom_plan
)
select vp.nom_plan, fe.fecha_actual, vp.valor_plan
from valores_plan vp
inner join fecha fe on fe.nom_plan = vp.nom_plan 
and vp.fecha_desde_plan = fe.fecha_actual
;
select * from valores_actuales;

drop table if exists valores_anteriores; 
create temporary table valores_anteriores
with fecha as(
select vp.nom_plan, max(vp.fecha_desde_plan) as fecha_anterior 
from valores_plan vp
inner join fecha_valores_actuales fva on fva.nom_plan = vp.nom_plan 
where fva.fecha_actual > vp.fecha_desde_plan 
group by vp.nom_plan)
select vp.nom_plan, fe.fecha_anterior, vp.valor_plan
from valores_plan vp
inner join fecha fe on fe.nom_plan = vp.nom_plan 
and vp.fecha_desde_plan = fe.fecha_anterior ; 

select * from valores_anteriores;

select va.nom_plan, va.fecha_actual, va.valor_plan, van.fecha_anterior, ifnull(van.valor_plan, 0) valor_anterior, ifnull(va.valor_plan - van.valor_plan, 0 ) as diferencia
from valores_actuales va
left join valores_anteriores van on van.nom_plan = va.nom_plan;


