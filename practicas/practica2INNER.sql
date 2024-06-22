

-- 1) Mostrar del Contrato 5:  
-- DNI, Apellido y Nombre de la persona contratada y el sueldo acordado en el contrato.

select con.dni, per.nombre, per.apellido, con.sueldo
from contratos con 
inner join personas per on con.dni = per.dni
where con.nro_contrato = 5; 

-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso? Mostrar el DNI, 
-- número de contrato, fecha de incorporación, fecha de solicitud en la agencia de los contratados y
--  fecha de caducidad (si no tiene fecha de caducidad colocar ‘Sin Fecha’).
--  Ordenado por fecha de incorporación y nombre de empresa

select per.dni, con.nro_contrato, con.fecha_incorporacion, con.fecha_solicitud,
ifnull(con.fecha_caducidad , "Sin Fecha") as fecha_caducidad
from empresas emp
inner join contratos con on con.cuit = emp.cuit
inner join personas per on per.dni = con.dni
where emp.razon_social = 'Viejos Amigos' or emp.razon_social = 'Traigame Eso';

-- 3) Listado de las solicitudes consignando razón social, dirección y e_mail de la empresa, 
-- descripción del cargo solicitado y años de experiencia solicitados,
--  ordenado por fecha d solicitud y descripción de cargo. 
select  emp.razon_social, emp.direccion, emp.e_mail, car.desc_cargo, sol.anios_experiencia
from solicitudes_empresas sol
inner join empresas emp on sol.cuit = emp.cuit 
inner join cargos car on car.cod_cargo = sol.cod_cargo 
order by sol.fecha_solicitud, 4;
-- 4)¿Listar todos los candidatos con título de bachiller o un título de educación
-- no formal. Mostrar nombre y apellido, descripción del título y DNI. 

select per.dni, per.nombre, per.apellido, tit.desc_titulo
from personas_titulos per_tit
inner join personas per on per.dni = per_tit.dni
inner join titulos tit on per_tit.cod_titulo = tit.cod_titulo
where tit.desc_titulo = 'Bachiller' or tit.tipo_titulo = 'Educacion no formal';  

-- 5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.

select per.nombre, per.apellido, tit.desc_titulo
from personas_titulos per_tit
inner join personas per on per.dni = per_tit.dni
inner join titulos tit on per_tit.cod_titulo = tit.cod_titulo;  

-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando Esteban Quito o Felipe Rojas.
-- Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia S.A

select concat( concat(per.nombre, ' ' , per.apellido) , 
ifnull(ant.persona_contacto, ' No tiene referencia ') ,
 if(ant.persona_contacto is not null, ' tiene como referencia a ' , ant.persona_contacto),
 concat( "y trabajo en " , emp.razon_social )) as informacion_completa
 from antecedentes ant
 inner join personas per on per.dni = ant.dni
 inner join empresas emp on ant.cuit = emp.cuit
 where ant.persona_contacto is null 
 or ant.persona_contacto= 'Armando Esteban Quito' 
 or ant.persona_contacto= 'Felipe Rojas'; 

-- 7)Seleccionar para la empresa Viejos amigos, fechas de solicitudes,
-- descripción del cargo solicitado y edad máxima  y mínima . 
-- Si no tiene edad mínima y máxima indicar “sin especificar”. Encabezado:
 select sol.fecha_solicitud, car.desc_cargo, 
 if(sol.edad_maxima is null, 'sin especificar', sol.edad_maxima) as edad_maxima , if(sol.edad_minima is null, 'sin especificar',sol.edad_minima) as edad_minima
from empresas emp
inner join solicitudes_empresas sol on emp.cuit = sol.cuit
inner join cargos car on car.cod_cargo = sol.cod_cargo
where emp.razon_social = "Viejos amigos";

-- 8) Mostrar los antecedentes de cada postulante:
select concat(per.nombre, ' ', per.apellido) as postulante, car.desc_cargo as cargo 
from personas per 
inner join antecedentes ant on per.dni = ant.dni
inner join cargos car on car.cod_cargo = ant.cod_cargo; 

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma 
-- ascendente por empresa y descendente por cargo:
select emp.razon_social,car.desc_cargo, eva.desc_evaluacion, ent_eva.resultado  
from empresas emp
inner join solicitudes_empresas sol on emp.cuit = sol.cuit
inner join entrevistas ent 
on sol.cuit = ent.cuit 
AND ent.cod_cargo = sol.cod_cargo And ent.fecha_solicitud = ent.fecha_solicitud
inner join entrevistas_evaluaciones ent_eva on ent_eva.nro_entrevista =ent.nro_entrevista
inner join evaluaciones eva on eva.cod_evaluacion = ent_eva.cod_evaluacion 
inner join cargos car on car.cod_cargo = sol.cod_cargo
order by 1 asc, 2 desc; 

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
--  y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la leyenda:
--  Sin Solicitudes en la fecha y en  la descripción del cargo.

select emp.razon_social, 
if(sol_emp.fecha_solicitud is null, 'sin solicitud',sol_emp.fecha_solicitud) as fecha_solicitud,
if(car.desc_cargo is null, 'sin solicitud',car.desc_cargo) as descripcion_cargo
from empresas emp
left join solicitudes_empresas sol_emp on emp.cuit = sol_emp.cuit 
left join cargos car on sol_emp.cod_cargo = car.cod_cargo;

-- 11)
select sol.cuit, emp.razon_social, car.desc_cargo, con.dni, con.fecha_incorporacion ,per.nombre, per.apellido
from solicitudes_empresas sol
inner join empresas emp on sol.cuit = emp.cuit
inner join cargos car on sol.cod_cargo = car.cod_cargo
left join contratos con on
sol.cuit = con.cuit 
and sol.cod_cargo = con.cod_cargo 
and sol.fecha_solicitud = con.fecha_solicitud
left join personas per on con.dni = per.dni
order by sol.cuit; 

-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, 
-- el cargo de las solicitudes para las cuales no se haya realizado un contrato. 
select emp.cuit, emp.razon_social, car.desc_cargo
from solicitudes_empresas sol_emp
inner join empresas emp on emp.cuit = sol_emp.cuit
left join contratos con 
on sol_emp.cuit = con.cuit 
and sol_emp.cod_cargo =con.cod_cargo 
and sol_emp.fecha_solicitud = con.fecha_solicitud
inner join cargos car on car.cod_cargo = sol_emp.cod_cargo
where con.nro_contrato is null;  

-- 13) Listar todos los cargos y para aquellos que hayan sido realizados (como antecedente) 
-- por alguna persona indicar nombre y apellido de la persona y empresa donde lo ocupó.

select car.desc_cargo, if(per.dni is null, 'Sin antecedentes',per.dni ) as DNI,
if(per.apellido is null, 'Sin antecedentes',per.apellido ) as apellido , emp.razon_social
from cargos car
left join antecedentes ant on ant.cod_cargo = car.cod_cargo 
left join personas per on per.dni = ant.dni
left join empresas emp on ant.cuit = emp.cuit;







