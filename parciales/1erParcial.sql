/* 301.1-Presentadores que aparecieron en Orth.
 Listar los presentadores de alguna presentación realizada en locaciones de zona de "Orth".
 Indicar el id, nombre, apellido y denominación del presentador; nombre, tipo de presentación
 y fecha y hora de inicio. Ordenar ascendente por cuit del presentador y 
 fecha de inicio de la presentación descendente.*/
 select pre.id,pre.nombre, pre.apellido, pre.denominacion, pres.nombre, pres.tipo, pres.fecha_hora_ini
 from presentador pre 
 inner join presentador_presentacion pp on pre.id = pp.id_presentador
 inner join presentacion pres 
 on pres.id_locacion = pp.id_locacion 
 and pres.nro_sala = pp.nro_sala
 and pres.fecha_hora_ini = pp.fecha_hora_ini 
 inner join locacion loc on pres.id_locacion = loc.id
 where loc.zona = "Orth"
 order by pre.cuit asc, pres.fecha_hora_ini desc ;
 
 
 
 /*301.2-Supervisores y si fueron coordinadores en eventos. 
 Listar los empleados con categoría supervisor y, solo para los que hayan ocupado el rol de “coordinador” 
 para algún evento, mostrar el/los eventos para el que lo ocuparon,
 el resto mostrar null. Indicar cuil, nombre y apellido del empleado; id, nombre y tipo del evento.*/
 
 select emp.cuil, emp.nombre, emp.apellido, eve.id, eve.nombre, eve.tipo
 from empleado emp 
 left join encargado_evento ee on ee.cuil_encargado = emp.cuil and ee.rol = "coordinador"
 left join evento eve on eve.id = ee.id_evento
 where emp.categoria = "Supervisor" ;
 
 


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 