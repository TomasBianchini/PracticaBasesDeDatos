/*Crear una función llamada alumnos_deudas_a_fecha que dado un alumno y una fecha indique cuantas cuotas adeuda a la fecha.*/

SET GLOBAL log_bin_trust_function_creators = 1;
select alu.dni, alu.nombre, alumnos_deudas_a_fecha(alu.dni, curdate()) cantidad
from alumnos alu
;

/*Crear un procedimiento almacenado llamado alumnos_pagos_deudas_a_fecha que dada una fecha y un alumno indique cuanto ha pagado hasta esa fecha y cuantas cuotas adeudaba a dicha fecha (cuotas emitidas y no pagadas). Devolver los resultados en parámetros de salida.*/

call alumnos_pagos_deudas_a_fecha(24242424, curdate(), @importe_pagado ,@cant_deuda); 
select  @importe_pagado ,@cant_deuda;

/*Crear un procedimiento almacenado llamado alumno_inscripcion que dados los datos de un alumno y un curso lo inscriba en dicho curso el día de hoy y genere la primera cuota con fecha de emisión hoy para el mes próximo.*/
/*AFATSE*/
CREATE DEFINER=`root`@`localhost` FUNCTION `plan_valor`(plan varchar(20), fecha date ) RETURNS float(9,3)
    DETERMINISTIC
BEGIN
select  max(vp.fecha_desde_plan) into @fecha_actual
from valores_plan vp
where vp.fecha_desde_plan <= fecha and vp.nom_plan = plan
group by vp.nom_plan;
select vp.valor_plan into @valor
from valores_plan vp
where vp.fecha_desde_plan = @fecha_actual and vp.nom_plan = plan;

RETURN @valor;
END




CREATE DEFINER=`root`@`localhost` FUNCTION `alumnos_deudas_a_fecha`(dni int, fecha date) RETURNS int
reads sql data
BEGIN
select count(*) into @cant
from cuotas cu 
where cu.fecha_pago is null and cu.dni = dni and cu.fecha_emision < curdate();
RETURN @cant;
END



CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_actual`()
BEGIN
with fecha_actual as(
select vp.nom_plan, max(vp.fecha_desde_plan) as fecha
from valores_plan vp
group by vp.nom_plan
)
select fa.nom_plan, plan.modalidad, vp.valor_plan
from fecha_actual fa
inner join valores_plan vp on vp.nom_plan = fa.nom_plan 
inner join plan_capacitacion plan on plan.nom_plan = fa.nom_plan 
where fa.fecha = vp.fecha_desde_plan;
END





CREATE DEFINER=`root`@`localhost` PROCEDURE `plan_lista_precios_a_fecha`(a_fecha date)
BEGIN
/*2)with fecha_actual as(
select vp.nom_plan, max(vp.fecha_desde_plan) as fecha
from valores_plan vp
where vp.fecha_desde_plan <= a_fecha
group by vp.nom_plan
)
select vp.nom_plan, plan.modalidad, vp.valor_plan
from plan_capacitacion plan
inner join valores_plan vp on vp.nom_plan = plan.nom_plan 
inner join fecha_actual fa on fa.nom_plan = plan.nom_plan
where vp.fecha_desde_plan = fa.fecha ; */
/*5)*/ select distinct vp.nom_plan, plan_valor(vp.nom_plan, fecha)
from valores_plan vp;
END




CREATE DEFINER=`root`@`localhost` PROCEDURE `alumno_inscripcion`(dni_a int, i_nom_plan char(20), i_nro_curso int)
BEGIN
declare inscripto boolean; 
declare cupos int; 
declare inscriptos int; 
select false into inscripto;
start transaction; 
select true into inscripto 
from inscripciones ins 
where dni_a = ins.dni and ins.nom_plan = i_nom_plan and i_nro_curso = ins.nro_curso  ; 

INSERT INTO inscripciones (nom_plan, nro_curso, dni, fecha_inscripcion)
SELECT i_nom_plan, i_nro_curso, dni_a, CURDATE()
WHERE NOT inscripto;

insert into cuotas (nom_plan, nro_curso, dni, anio, mes, fecha_emision, fecha_pago, importe_pagado)
select i_nom_plan, i_nro_curso, dni_a, year(curdate()), month(curdate()), curdate(), null, null
where inscripto = false;

select cupo into cupos 
from cursos cur 
where cur.nom_plan = i_nom_plan and cur.nro_curso = i_nro_curso;
select count(*) into inscriptos
from inscripciones ins 
inner join cursos cur on ins.nom_plan = cur.nom_plan and cur.nro_curso = ins.nro_curso;
if cupos < inscripciones then 
		rollback;
	else  commit;
    end if;
END





CREATE DEFINER=`root`@`localhost` PROCEDURE `alumnos_pagos_deudas_a_fecha`( in a_dni int, in fecha date, out importe decimal, out cuotas_adeudada int)
BEGIN
select count(*) into cuotas_adeudada
from cuotas cu
where cu.fecha_pago is null and cu.fecha_emision <= fecha and cu.dni = a_dni; 
select sum(cu.importe_pagado ) into importe
from cuotas cu
where a_dni = cu.dni and cu.fecha_pago <= fecha and fecha_pago is not null; 
END





