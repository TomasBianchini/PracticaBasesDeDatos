-- 14) Indicar todos los instructores que tengan un supervisor. Mostrar:

select ins.cuil as cuil_Instructor, 
 ins.nombre as nombre_Instructor, ins.apellido as apeliido_Instructor, 
 sup.cuil as cuil_supervisor, sup.nombre as nombre_supervisor, sup.apellido as apellido_supervisor
from instructores ins 
inner join instructores sup on ins.cuil_supervisor = sup.cuil; 
-- Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos campos en blanco

select ins.cuil as cuil_Instructor, 
 ins.nombre as nombre_Instructor, ins.apellido as apeliido_Instructor, 
 ifnull(sup.cuil," ")as cuil_supervisor,  ifnull(sup.nombre, " ") as nombre_supervisor,
  ifnull(sup.apellido, " ") as apellido_supervisor
from instructores ins 
left join instructores sup on ins.cuil_supervisor = sup.cuil; 
-- 16) Ranking de Notas por Supervisor e Instructor.
--  El ranking deberá indicar para cada supervisor los instructores a su cargo y
--  las notas de los exámenes que el instructor haya corregido en el 2014. Indicando los datos del supervisor , 
-- nombre y apellido del instructor, plan de capacitación, curso, nombre y apellido del alumno, examen,
--  fecha de evaluación y nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco.
--  Ordenado ascendente por nombre y apellido de supervisor y descendente por fecha.

select  ifnull(sup.cuil," ")as cuil_supervisor,  ifnull(sup.nombre, " ") as nombre_supervisor,
  ifnull(sup.apellido, " ") as apellido_supervisor,
 ins.cuil as cuil_Instructor, 
 ins.nombre as nombre_Instructor, ins.apellido as apeliido_Instructor, al.nombre, al.apellido,
 eva.nom_plan, eva.nro_curso, eva.fecha_evaluacion,  eva.nota
from instructores ins 
left join instructores sup on ins.cuil_supervisor = sup.cuil
inner join evaluaciones eva on eva.cuil = ins.cuil
inner join alumnos al on al.dni = eva.dni
order by 1 asc, 2 asc, eva.fecha_evaluacion desc;







