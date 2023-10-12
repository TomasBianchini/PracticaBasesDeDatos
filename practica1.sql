-- 2) 
Select per.nombre, per.apellido, per.fecha_registro_agencia 
from personas per; 
-- 3
select tit.cod_titulo, tit.desc_titulo, tit.tipo_titulo from titulos tit
order by 2 asc; 
-- 4 
select concat(per.nombre, ' ', per.apellido) as nombreCompleto, per.telefono, per.direccion 
from personas per
where dni = 28675888;
-- 5 
select per.nombre, per.apellido, per.fecha_nacimiento, per.telefono , per.direccion
from personas per
where per.dni = 27890765 or per.dni = 29345777 or per.dni = 31345778
order by 3 asc;
-- 6
select * 
from personas per
where per.apellido like "G%"; 
-- 7
select per.nombre, per.apellido, per.fecha_nacimiento
from personas per
where YEAR(per.fecha_nacimiento) >= 1980 AND YEAR(per.fecha_nacimiento) <= 2000
-- YEAR(fecha_nac) between 1980 and 2000
;
-- 8
select * 
from solicitudes_empresas sol_emp
order by fecha_solicitud asc; 

-- 9
select * 
from antecedentes ant
where fecha_hasta is null; 

-- 10 
select * 
from antecedentes ant
where ant.fecha_hasta is not null and (ant.fecha_hasta not between "2013-05-30" and "2014-01-01" )
order by dni;

-- 11
select con.cuit, con.nro_contrato, con.dni, con.sueldo
from contratos con
where (con.cuit = '30-10504876-5' or con.cuit= '30-21098732-4' ) and con.sueldo > 2000;


-- 12 
select * 
from titulos tit 
where tit.desc_titulo like "Tecnico%"; 
-- 13 Seleccionar las solicitudes cuya fecha sea mayor que ‘21/09/2013’ y el código de cargo sea 6;
--  o hayan solicitado aspirantes de sexo femenino
select * 
from solicitudes_empresas sol
where (sol.fecha_solicitud > "2013/09/21" and cod_cargo = 6 ) or sexo = "femenino";
-- 14  Seleccionar los contratos con un salario pactado mayor que 2000 y que no hayan sido terminado.
select *
from contratos con
where con.sueldo > 2000 And con.fecha_caducidad is null; 
















