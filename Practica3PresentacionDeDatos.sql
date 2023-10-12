-- 1) Para aquellos contratos que no hayan terminado calcular
--  la fecha de caducidad como la fecha de solicitud más 30 días (no actualizar la base de datos).
--  Función ADDDATE

select con.nro_contrato, con.fecha_incorporacion, con.fecha_finalizacion_contrato, 
adddate(con.fecha_solicitud, interval 30 day) as fecha_caducidad
from contratos con 
where con.fecha_caducidad is null;
-- 2)Mostrar los contratos. Indicar nombre y apellido de la persona,
-- razón social de la empresa fecha de inicio del contrato y fecha de caducidad del contrato. 
-- Si la fecha no ha terminado mostrar “Contrato Vigente”. Función IFNULL
select per.nombre, per.apellido, emp.razon_social, con.fecha_incorporacion, 
ifnull(con.fecha_caducidad, "Contarto Vigente") as fecha_caducidad
from personas per 
inner join contratos con on con.dni = per.dni
inner join empresas emp on emp.cuit = con.cuit;

/* 3) Para aquellos contratos que terminaron antes de la fecha de finalización,
 indicar la cantidad de días que finalizaron antes de tiempo. Función DATEDIFF*/
 select con.nro_contrato, con.fecha_incorporacion, con.fecha_finalizacion_contrato, con.fecha_caducidad,
con.sueldo, con.porcentaje_comision, con.dni, con.cuit, con.cod_cargo, con.fecha_solicitud, 
 Datediff(con.fecha_finalizacion_contrato, con.fecha_caducidad) as dias_antes
from contratos con
where con.fecha_finalizacion_contrato > con.fecha_caducidad;
/* 4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, 
razón social de la empresa y dirección, año y mes de la comisión, }
importe y la fecha de vencimiento que se calcula como la fecha actual más dos meses.
 Función ADDDATE con INTERVAL */
 select emp.cuit, emp.razon_social, emp.direccion, com.anio_contrato,
 com.mes_contrato, com.importe_comision, Adddate(current_date(), interval 2 month) as fecha_vencimiento
 from comisiones com 
 inner join contratos con on con.nro_contrato = com.nro_contrato
 inner join empresas emp on emp.cuit = con.cuit
 where com.fecha_pago is null; 
 
 /* 5) Mostrar en qué día mes y año nacieron las personas (mostrarlos en columnas separadas) 
 y sus nombres y apellidos concatenados. Funciones DAY, YEAR, MONTH y CONCAT */
 select Day(per.fecha_nacimiento) as 'day', Month(per.fecha_nacimiento) AS 'Month', year(per.fecha_nacimiento) AS 'YEAR',
 concat(per.nombre, " ", per.apellido) as 'nombre y apellido'
 from personas per; 

 
 
 
 
 
 
 
 