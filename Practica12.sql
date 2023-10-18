SET AUTOCOMMIT=1;
/*Crear un nuevo alumno e inscribirlo a Marketing 3 curso nro. 1 sin utilizar START TRANSACTION. */



insert into alumnos (dni,nombre,apellido,tel,email,direccion) values(42555120, 'tomas', 'bianchini','3406421829' , 'tb@gmail.com', 'zeballos 1348');

insert into inscripciones (nom_plan, nro_curso, dni , fecha_inscripcion) values ('Marketing 3', 1, 42555120, curdate());
 delete from alumnos where dni = 42555120;
 delete from inscripciones where dni = 42555120 and nom_plan = 'Marketing 3' and nro_curso =  1;
