-- DIFICULTAD: Muy Fácil

-- 1 .Devuelve todas las películas
SELECT * FROM PUBLIC.MOVIES;

-- 2. Devuelve todos los géneros existentes
SELECT * FROM PUBLIC.GENRES;

-- 3. Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM PUBLIC.STUDIOS WHERE STUDIO_ACTIVE = 1;

-- 4. Devuelve una lista de los 20 últimos miembros en anotarse al videoclub
SELECT * FROM PUBLIC.MEMBERS 
ORDER BY MEMBER_DISCHARGE_DATE DESC 
LIMIT 20;

-- DIFICULTAD: Fácil

-- 5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.
SELECT MOVIE_DURATION, COUNT(*) AS MORE_FRECUENT FROM PUBLIC.MOVIES
GROUP BY MOVIE_DURATION 
ORDER BY MORE_FRECUENT DESC, MOVIE_DURATION DESC 
LIMIT 20;

-- 6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT * FROM PUBLIC.MOVIES
WHERE YEAR (MOVIE_LAUNCH_DATE) >= 2000
AND MOVIE_NAME LIKE 'A%';

-- 7. Devuelve los actores nacidos un mes de Junio
SELECT * FROM PUBLIC.ACTORS
WHERE MONTH (ACTOR_BIRTH_DATE) = 06;

-- 8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.
SELECT * FROM PUBLIC.ACTORS
WHERE MONTH (ACTOR_BIRTH_DATE) != 06
AND ACTOR_DEAD_DATE IS NULL;

-- 9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT DIRECTOR_NAME, YEAR(CURDATE()) - YEAR(DIRECTOR_BIRTH_DATE) AS DIRECTOR_AGE
FROM PUBLIC.DIRECTORS
WHERE YEAR(CURDATE()) - YEAR(DIRECTOR_BIRTH_DATE) <= 50
AND DIRECTOR_DEAD_DATE IS NULL;

-- 10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT ACTOR_NAME, YEAR(CURDATE()) - YEAR(ACTOR_BIRTH_DATE) AS ACTOR_AGE
FROM PUBLIC.ACTORS
WHERE YEAR(CURDATE()) - YEAR(ACTOR_BIRTH_DATE) < 50
AND ACTOR_DEAD_DATE IS NOT NULL;

-- 11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT DIRECTOR_NAME
FROM PUBLIC.DIRECTORS
WHERE YEAR(CURDATE()) - YEAR(DIRECTOR_BIRTH_DATE) <= 40
AND DIRECTOR_DEAD_DATE IS NULL;

-- 12. Indica la edad media de los directores vivos
SELECT AVG(YEAR(CURDATE()) - YEAR(DIRECTOR_BIRTH_DATE))
FROM PUBLIC.DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL;

-- 13. Indica la edad media de los actores que han fallecido
SELECT AVG(YEAR(ACTOR_DEAD_DATE) - YEAR(ACTOR_BIRTH_DATE))
FROM PUBLIC.ACTORS
WHERE ACTOR_DEAD_DATE IS NOT NULL;

-- DIFICULTAD: Media

-- 14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT M.MOVIE_NAME, S.STUDIO_NAME
FROM PUBLIC.MOVIES M
JOIN PUBLIC.STUDIOS S ON S.STUDIO_ID = M.STUDIO_ID 
WHERE M.STUDIO_ID = S.STUDIO_ID;

-- 15. Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT MEMBERS.MEMBER_NAME, MOV_RENT.MEMBER_RENTAL_DATE 
FROM PUBLIC.MEMBERS MEMBERS
JOIN PUBLIC.MEMBERS_MOVIE_RENTAL MOV_RENT ON MOV_RENT.MEMBER_ID = MEMBERS.MEMBER_ID 
WHERE YEAR(MOV_RENT.MEMBER_RENTAL_DATE) BETWEEN 2010 AND 2015;

-- 16. Devuelve cuantas películas hay de cada país
SELECT COUNT(*) AS NUM_MOVIES, COUNTRY.NATIONALITY_NAME 
FROM PUBLIC.MOVIES MOVIES
JOIN PUBLIC.NATIONALITIES COUNTRY ON COUNTRY.NATIONALITY_ID = MOVIES.NATIONALITY_ID 
GROUP BY COUNTRY.NATIONALITY_NAME;


-- 17. Devuelve todas las películas que hay de género documental
SELECT MOVIE.MOVIE_NAME, GEN.GENRE_NAME
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.GENRES GEN ON GEN.GENRE_ID = MOVIE.GENRE_ID 
WHERE GEN.GENRE_NAME = 'Documentary';

-- 18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT MOVIE.*
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.DIRECTORS DIRECTOR ON DIRECTOR.DIRECTOR_ID = MOVIE.DIRECTOR_ID 
WHERE YEAR(DIRECTOR.DIRECTOR_BIRTH_DATE) > 1980 AND 
DIRECTOR.DIRECTOR_DEAD_DATE IS NULL;

-- 19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.
SELECT MEMBER.MEMBER_NAME, DIRECTOR.DIRECTOR_NAME, MEMBER.MEMBER_TOWN
FROM PUBLIC.MEMBERS MEMBER
INNER JOIN PUBLIC.DIRECTORS DIRECTOR ON DIRECTOR.DIRECTOR_BIRTH_PLACE = MEMBER.MEMBER_TOWN 
WHERE DIRECTOR.DIRECTOR_BIRTH_PLACE = MEMBER.MEMBER_TOWN;

-- 20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT DISTINCT MOVIE_NAME, YEAR(MOVIE_LAUNCH_DATE)
FROM PUBLIC.MOVIES
JOIN PUBLIC.STUDIOS ON STUDIO_ID = STUDIO_ID 
WHERE STUDIO_ACTIVE = 0;

-- 21. Devuelve una lista de las últimas 10 películas que se han alquilado
SELECT DISTINCT MOVIE_ID, MOVIE_NAME
FROM PUBLIC.MOVIES
INNER JOIN PUBLIC.MEMBERS_MOVIE_RENTAL ON MOVIE_ID = MOVIE_ID 
ORDER BY YEAR(MEMBER_RENTAL_DATE) DESC
LIMIT 10;

-- 22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT DIRECTOR.DIRECTOR_NAME, COUNT(MOVIE.MOVIE_ID) AS PELIS
FROM PUBLIC.DIRECTORS DIRECTOR
JOIN PUBLIC.MOVIES MOVIE ON DIRECTOR.DIRECTOR_ID = MOVIE.DIRECTOR_ID 
WHERE DATEDIFF(YEAR(MOVIE.MOVIE_LAUNCH_DATE), YEAR(DIRECTOR.DIRECTOR_BIRTH_DATE)) < 41
GROUP BY DIRECTOR.DIRECTOR_NAME;

-- 23. Indica cuál es la media de duración de las películas de cada director
SELECT AVG(MOVIE.MOVIE_DURATION), DIRECTOR.DIRECTOR_NAME
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.DIRECTORS DIRECTOR ON DIRECTOR.DIRECTOR_ID = MOVIE.DIRECTOR_ID 
GROUP BY DIRECTOR.DIRECTOR_NAME;

-- 24. Indica cuál es el nombre y la duración mínima de la película que ha sido alquilada en los últimos 2 años por los miembros del videoclub (La "fecha de ejecución" en este script es el 25-01-2019)
SELECT MOVIE.MOVIE_NAME, MIN(MOVIE.MOVIE_DURATION) AS MIN_DURATION
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.MEMBERS_MOVIE_RENTAL MR ON MOVIE.MOVIE_ID = MR.MOVIE_ID
WHERE MR.MEMBER_RENTAL_DATE >= '2017-01-25'
GROUP BY MOVIE.MOVIE_NAME
ORDER BY MIN_DURATION ASC
LIMIT 1;

-- 25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título
SELECT COUNT(MOVIE.MOVIE_ID) AS NMOVIE
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.DIRECTORS DIRECTOR ON MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID
WHERE MOVIE.MOVIE_NAME LIKE '%The%' 
AND YEAR(MOVIE.MOVIE_LAUNCH_DATE) BETWEEN 1960 AND 1989;


-- DIFICULTAD: Difícil 

-- 26. Lista nombre, nacionalidad y director de todas las películas
SELECT MOVIE.MOVIE_NAME , NAT.NATIONALITY_NAME , DIRECTOR.DIRECTOR_NAME 
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.DIRECTORS DIRECTOR ON MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID 
JOIN PUBLIC.NATIONALITIES NAT ON MOVIE.NATIONALITY_ID = NAT.NATIONALITY_ID;

-- 27. Muestra las películas con los actores que han participado en cada una de ellas
SELECT MOVIE.MOVIE_NAME, ACTOR.ACTOR_NAME
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.MOVIES_ACTORS MA ON MOVIE.MOVIE_ID = MA.MOVIE_ID 
JOIN PUBLIC.ACTORS ACTOR ON MA.ACTOR_ID = ACTOR.ACTOR_ID;

-- 28. Indica cual es el nombre del director del que más películas se han alquilado
SELECT DIRECTOR.DIRECTOR_NAME, COUNT(MOVIE_RENTAL.MOVIE_ID) AS CUENTA
FROM PUBLIC.MEMBERS_MOVIE_RENTAL MOVIE_RENTAL
JOIN PUBLIC.MOVIES MOVIE ON MOVIE_RENTAL.MOVIE_ID = MOVIE.MOVIE_ID 
JOIN PUBLIC.DIRECTORS DIRECTOR ON MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID 
GROUP BY DIRECTOR.DIRECTOR_NAME 
ORDER BY CUENTA DESC
LIMIT 1;

-- 29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado

-- 30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)

-- 31. Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT COUNT(ACTOR.ACTOR_ID) AS N_ACTOR
FROM PUBLIC.ACTORS ACTOR
JOIN PUBLIC.MOVIES_ACTORS MA ON MA.ACTOR_ID = ACTOR.ACTOR_ID
JOIN PUBLIC.MOVIES MOVIE ON MA.MOVIE_ID = MOVIE.MOVIE_ID
JOIN PUBLIC.STUDIOS STUDIO ON MOVIE.STUDIO_ID = STUDIO.STUDIO_ID
WHERE STUDIO.STUDIO_ACTIVE = 0;

SELECT COUNT(DIRECTOR.DIRECTOR_ID) AS N_DIR
FROM PUBLIC.DIRECTORS DIRECTOR
JOIN PUBLIC.MOVIES MOVIE ON MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID
JOIN PUBLIC.STUDIOS STUDIO ON MOVIE.STUDIO_ID = STUDIO.STUDIO_ID
WHERE STUDIO.STUDIO_ACTIVE = 0;

-- 32. Indica el nombre, ciudad, y teléfono de todos los miembros del videoclub que hayan alquilado películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT MEMBER.MEMBER_NAME, MEMBER.MEMBER_TOWN, MEMBER.MEMBER_PHONE
FROM PUBLIC.MEMBERS MEMBER
JOIN PUBLIC.MEMBERS_MOVIE_RENTAL MR ON MEMBER.MEMBER_ID = MR.MEMBER_ID
JOIN PUBLIC.MOVIES MOVIE ON MR.MOVIE_ID = MOVIE.MOVIE_ID
JOIN PUBLIC.AWARDS AWARD ON MOVIE.MOVIE_ID = AWARD.MOVIE_ID
WHERE AWARD.AWARD_NOMINATION > 150 AND AWARD.AWARD_WIN < 50
GROUP BY MEMBER.MEMBER_NAME, MEMBER.MEMBER_TOWN, MEMBER.MEMBER_PHONE;


-- 33. Comprueba si hay errores en la BD entre las películas y directores (un director fallecido en el 76 no puede dirigir una película en el 88)
SELECT MOVIE.MOVIE_NAME, MOVIE.MOVIE_LAUNCH_DATE, DIRECTOR.DIRECTOR_NAME, DIRECTOR.DIRECTOR_DEAD_DATE
FROM PUBLIC.MOVIES MOVIE
JOIN PUBLIC.DIRECTORS DIRECTOR ON MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID
WHERE DIRECTOR.DIRECTOR_DEAD_DATE IS NOT NULL
AND MOVIE.MOVIE_LAUNCH_DATE > DIRECTOR.DIRECTOR_DEAD_DATE;

-- 34. Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE PUBLIC.DIRECTORS DIRECTOR
SET DIRECTOR.DIRECTOR_DEAD_DATE = (
    SELECT DATE_ADD(MOVIE.MOVIE_LAUNCH_DATE, INTERVAL 1 YEAR)
    FROM PUBLIC.MOVIES MOVIE
    WHERE MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID
    AND MOVIE.MOVIE_LAUNCH_DATE > DIRECTOR.DIRECTOR_DEAD_DATE
)
WHERE EXISTS (
    SELECT 1
    FROM PUBLIC.MOVIES MOVIE
    WHERE MOVIE.DIRECTOR_ID = DIRECTOR.DIRECTOR_ID
    AND MOVIE.MOVIE_LAUNCH_DATE > DIRECTOR.DIRECTOR_DEAD_DATE
);

 
--DIFICULTAD: Berserk mode (enunciados simples, mucha diversión...)

-- 35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

-- 36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

-- 37. Indica cuál fue la primera película que alquilaron los miembros del videoclub cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad


