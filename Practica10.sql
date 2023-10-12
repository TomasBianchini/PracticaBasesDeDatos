/*Crear una función llamada alumnos_deudas_a_fecha que dado un alumno y una fecha indique cuantas cuotas adeuda a la fecha.*/

SET GLOBAL log_bin_trust_function_creators = 1;
select alu.dni, alu.nombre, alumnos_deudas_a_fecha(alu.dni, curdate()) cantidad
from alumnos alu
;

/*Crear un procedimiento almacenado llamado alumnos_pagos_deudas_a_fecha que dada una fecha y un alumno indique cuanto ha pagado hasta esa fecha y cuantas cuotas adeudaba a dicha fecha (cuotas emitidas y no pagadas). Devolver los resultados en parámetros de salida.*/

call alumnos_pagos_deudas_a_fecha(24242424, curdate(), @importe_pagado ,@cant_deuda); 
select  @importe_pagado ,@cant_deuda;

/*Crear un procedimiento almacenado llamado alumno_inscripcion que dados los datos de un alumno y un curso lo inscriba en dicho curso el día de hoy y genere la primera cuota con fecha de emisión hoy para el mes próximo.*/