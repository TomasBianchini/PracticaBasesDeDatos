-- 1) Mostrar las comisiones pagadas por la empresa Tráigame eso.
select emp.razon_social, sum(com.importe_comision)
from empresas emp
inner join contratos con on con.cuit = emp.cuit
inner join comisiones com on com.nro_contrato = con.nro_contrato
where emp.razon_social = 'Traigame eso'
group by 1;
-- 2) Ídem 1) pero para todas las empresas.
select emp.razon_social, sum(com.importe_comision)
from empresas emp
inner join contratos con on con.cuit = emp.cuit
inner join comisiones com on com.nro_contrato = con.nro_contrato
group by 1;
/* 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las evaluaciones de entrevistas, 
por tipo de evaluación y entrevistador.
 Ordenar por promedio en forma ascendente y luego por desviación estándar en forma descendente. */ 
 
select ent.nombre_entrevistador ,e_e.cod_evaluacion, 
AVG( e_e.resultado ) as promedio, STD( e_e.resultado ) as 'desviación estándar',
 variance(e_e.resultado) as varianza
from entrevistas ent
inner join entrevistas_evaluaciones e_e on e_e.nro_entrevista = ent.nro_entrevista
group by 2, 1 
order by 3 asc, 4 desc; 

/* 4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código de evaluación.*/
 select ent.nombre_entrevistador ,e_e.cod_evaluacion, 
AVG( e_e.resultado ) as promedio, STD( e_e.resultado ) as 'desviación estándar',
 variance(e_e.resultado) as varianza
from entrevistas ent
inner join entrevistas_evaluaciones e_e on e_e.nro_entrevista = ent.nro_entrevista
where ent.nombre_entrevistador = 'Angelica Doria' 
group by 2, 1 
having promedio > 71
order by promedio asc, 'desviación estándar' desc; 
-- 5)Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014.
select nombre_entrevistador, count(*) as 'Cantidad de entrevistas'
from entrevistas 
where year(fecha_entrevista) = 2014 and month(fecha_entrevista) = 10
group by 1;
/* 6) dem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad. 
Ordenado por cantidad de entrevistas. */
 select ent.nombre_entrevistador, e_e.cod_evaluacion, count(*),
AVG( e_e.resultado ) as promedio, STD( e_e.resultado ) as 'desviación estándar',
 variance(e_e.resultado) as varianza
from entrevistas ent
inner join entrevistas_evaluaciones e_e on e_e.nro_entrevista = ent.nro_entrevista
group by 2, 1
having promedio > 71
order by 3 asc; 
/* 7)  Ídem 6) para aquellos cuya cantidad de entrevistas por codigo de evaluacion sea myor mayor que 1. 
Ordenado por nombre en forma descendente y por codigo de evalucacion en forma ascendente */
 select ent.nombre_entrevistador, e_e.cod_evaluacion, count(*) AS CANT_ENTREVISTAS,
AVG( e_e.resultado ) as promedio, STD( e_e.resultado ) as 'desviación estándar',
 variance(e_e.resultado) as varianza
from entrevistas ent
inner join entrevistas_evaluaciones e_e on e_e.nro_entrevista = ent.nro_entrevista
group by 2,1
having CANT_ENTREVISTAS > 1
order by 3 asc; 
/* 8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar, cantidad a pagadas. */
SELECT con.nro_contrato, count(*) as total, count(case when com.fecha_pago is not null  THEN 1 END) as pagadas,
COUNT(*) - COUNT(CASE WHEN com.fecha_pago IS NOT NULL THEN 1 END) AS 'a pagar'
from contratos con 
inner join comisiones com on com.nro_contrato = con.nro_contrato
group by 1;
/* 9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y el % de impagas */ 
SELECT con.nro_contrato, count(*) as total,
 count(case when com.fecha_pago is not null  THEN 1 END)/count(*)*100 as pagadas,
(COUNT(*) - COUNT(CASE WHEN com.fecha_pago IS NOT NULL THEN 1 END) )/count(*)*100 AS 'a pagar'
from contratos con 
inner join comisiones com on com.nro_contrato = con.nro_contrato
group by 1;
/*10)Mostar la cantidad de empresas diferentes que han realizado solicitudes y 
la diferencia respecto al total de solicitudes.*/
select count(sol.cuit), count(*)
from empresas emp
left join solicitudes_empresas sol on emp.cuit = sol.cuit;
/*11)Cantidad de solicitudes por empresas.*/
select emp.cuit, emp.razon_social, count(*) 
from empresas emp 
left join solicitudes_empresas sol on emp.cuit = sol.cuit
group by 1,2;

/*12)Cantidad de solicitudes por empresas y cargos.*/
select emp.cuit, emp.razon_social, sol.cod_cargo, count(*)
from empresas emp 
inner join solicitudes_empresas sol on sol.cuit = emp.cuit 
group by 1,2,3;
 
 /* 13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes 
 que han mencionado dicha empresa como antecedente laboral.
 Si alguna empresa NO fue mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas. */
 select emp.cuit, emp.razon_social, ifnull(count(ant.cuit), 0) as "cantidad de personas"
 from empresas emp 
 left join antecedentes ant on ant.cuit = emp.cuit 
 group by 1,2; 
 
 /* 14) Indicar para cada cargo la cantidad de veces que fue solicitado.
 Ordenado en forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar 0.*/
 select car.cod_cargo, car.desc_cargo, ifnull(count(sol.cod_cargo), 0 ) as 'cantidad de solicitudes'
 from cargos car
 left join solicitudes_empresas sol on sol.cod_cargo = car.cod_cargo
 group by 1, 2 
 order by 3 desc;
 
 /*15)*/
  select car.cod_cargo, car.desc_cargo, ifnull(count(sol.cod_cargo), 0 ) as 'cantidad de solicitudes'
 from cargos car
 left join solicitudes_empresas sol on sol.cod_cargo = car.cod_cargo
  group by 1, 2 
 having count(sol.cod_cargo) < 2
 order by 3 desc;

 
 
 
 
 
 
 
 
 
 