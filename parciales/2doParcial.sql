/*301.3- Clientes que alquien stands dobles. Listar los clientes que hayan alquilado al menos 3 stands del tipo "doble". 
Indicar cuit, razón social, categoría e email del cliente; 
cantidad de stands dobles alquilados, promedio del valor acordado en el contrato y diferencia entre el máximo y mínimo valor acordado*/

select cli.cuit, cli.razon_social, cli.categoria, cli.email, count(*),
 avg(st.valor_acordado), max(st.valor_acordado) - min(st.valor_acordado)
 from cliente cli 
 inner join stand st on st.cuit_cliente = cli.cuit 
 where st.tipo = "doble"
 group by cli.cuit, cli.razon_social, cli.categoria, cli.email
 having count(*) >= 3;



