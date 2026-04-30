/* VERIFICA CONTEGGI RIHE */

SELECT COUNT(*) AS n_hotels FROM hotels;

SELECT COUNT(*) AS n_hotel_stats FROM hotel_stats;

SELECT COUNT(*) AS n_reviewers FROM reviewers;

SELECT COUNT(*) AS n_reviews FROM reviews;


/* VERIFICA JOIN TRA hotels e reviews */

SELECT COUNT(*) AS n_hotels FROM hotels;

SELECT COUNT(*) AS n_hotel_stats FROM hotel_stats;

SELECT COUNT(*) AS n_reviewers FROM reviewers;

SELECT COUNT(*) AS n_reviews FROM reviews;


/*Verifica per hotel per controllare quante recensioni ha ogni hotel */
SELECT 

    h.hotel_id,

    h.hotel_name,

    COUNT(r.review_id) AS numero_recensioni

FROM hotels h

LEFT JOIN reviews r

    ON h.hotel_id = r.hotel_id

GROUP BY h.hotel_id, h.hotel_name

ORDER BY numero_recensioni DESC;

_____________________________________________________________________________________________________________________________________
/* il join tra hotels e reviews restituisce risultati per ogni hotel si ottiene dunque il numero di recensioni associate e l’ordinamento 
decrescente funziona, quindi si visualizzano gli hotel con più recensioni. Per esempio, nel risultato ottenuto Britannia International Hotel
Canary Wharf hanno 4789 recensioni. Strand Palace Hotel ha 4256 e Park Plaza Westminster Bridge London totalizza 4169 recensioni.Quindi
questa verifica del join hotel-reviews la posso considerare riuscita.*/
_____________________________________________________________________________________________________________________________________

/* Distribuzione score per nazionalità */
SELECT

    rv.reviewer_nationality,

    COUNT(r.review_id) AS numero_recensioni,

    ROUND(AVG(r.reviewer_score), 2) AS score_medio,

    MIN(r.reviewer_score) AS score_min,

    MAX(r.reviewer_score) AS score_max

FROM reviews r

JOIN reviewers rv

    ON r.reviewer_id = rv.reviewer_id

GROUP BY rv.reviewer_nationality

ORDER BY numero_recensioni DESC;
_____________________________________________________________________________________________________________________________________
/* La relazione tra hotels e reviews è stata verificata tramite una query di join su hotel_id, con conteggio del numero di recensioni 
per hotel. Il risultato mostra valori coerenti e conferma il corretto collegamento tra chiave primaria della tabella hotels e chiave 
esterna della tabella reviews. */
_____________________________________________________________________________________________________________________________________

/*4.3 ANALISI CON SQL*/
/* Andamento recensioni per anno e mese */
SELECT

    review_year,

    review_month,

    COUNT(*) AS numero_recensioni

FROM reviews

GROUP BY review_year, review_month

ORDER BY review_year, review_month;
_______________________________________________________________________________________________________________________________________
/*L’analisi temporale delle recensioni mostra il numero di review pubblicate per anno e mese. I risultati evidenziano una variazione nel
volume delle recensioni nel tempo, con alcuni mesi che registrano un numero più elevato di recensioni rispetto ad altri periodi. Questo permette
di individuare eventuali pattern stagionali che si concentrano particolarmente nel periodo estivo.*/
________________________________________________________________________________________________________________________________________

/* Hotel con picco recensioni */

SELECT

    h.hotel_name,

    r.review_year,

    r.review_month,

    COUNT(*) AS numero_recensioni

FROM reviews r

JOIN hotels h

    ON r.hotel_id = h.hotel_id

GROUP BY h.hotel_name, r.review_year, r.review_month

ORDER BY numero_recensioni DESC

LIMIT 10;
__________________________________________________________________________________________________________________________________________
/*L’analisi dei picchi di recensioni per hotel evidenzia che alcune strutture concentrano un volume particolarmente elevato di recensioni 
in specifici mesi. Tra i casi più rilevanti emerge lo Strand Palace Hotel, che raggiunge il picco massimo a febbraio 2016 con 304 recensioni. 
Questo suggerisce la presenza maggiore di soggiorni in determinati periodi dell'anno.*/
__________________________________________________________________________________________________________________________________________

/*Nazionalità recensori*/
SELECT

    rv.reviewer_nationality,

    COUNT(r.review_id) AS numero_recensioni,

    ROUND(AVG(r.reviewer_score), 2) AS score_medio

FROM reviews r

JOIN reviewers rv

    ON r.reviewer_id = rv.reviewer_id

GROUP BY rv.reviewer_nationality

ORDER BY numero_recensioni DESC

LIMIT 10;

__________________________________________________________________________________________________________________________________________
/*L’analisi delle nazionalità dei recensori evidenzia una forte prevalenza di recensori provenienti dal Regno Unito, che rappresentano il gruppo
di gran lunga più numeroso. Seguono, a distanza significativa, Stati Uniti, Australia e Irlanda. Gli score medi risultano generalmente elevati 
per tutte le principali nazionalità, con alcune differenze tra i gruppi.*/
__________________________________________________________________________________________________________________________________________


/*% contributo top nazionalità al totale recensioni*/
SELECT

    TRIM(rv.reviewer_nationality) AS reviewer_nationality,

    COUNT(*) AS numero_recensioni,

    ROUND(COUNT(*) * 100.0 / t.totale_recensioni, 2) AS percentuale_sul_totale

FROM reviews r

JOIN reviewers rv

    ON r.reviewer_id = rv.reviewer_id

CROSS JOIN (

    SELECT COUNT(*) AS totale_recensioni

    FROM reviews

) t

GROUP BY TRIM(rv.reviewer_nationality), t.totale_recensioni

ORDER BY numero_recensioni DESC

LIMIT 10;
__________________________________________________________________________________________________________________________________________

/*La distribuzione percentuale delle principali nazionalità mostra una forte concentrazione delle recensioni nel gruppo dei recensori del Regno Unito,
che rappresentano il 47,72% del totale. Le altre nazionalità presentano quote molto più basse, con Stati Uniti e Australia che seguono a notevole 
distanza. Questo evidenzia una composizione del dataset fortemente sbilanciata verso il mercato britannico.*/
__________________________________________________________________________________________________________________________________________

/*Confronto score medio UK vs altri*/
SELECT

    CASE

        WHEN TRIM(rv.reviewer_nationality) = 'United Kingdom' THEN 'UK'

        ELSE 'Altre nazionalita'

    END AS gruppo,

    COUNT(*) AS numero_recensioni,

    ROUND(AVG(r.reviewer_score), 2) AS score_medio

FROM reviews r

JOIN reviewers rv

    ON r.reviewer_id = rv.reviewer_id

GROUP BY gruppo;

________________________________________________________________________________________________________________________________________________________
/*Il confronto tra recensori del Regno Unito e tutte le altre nazionalità mostra che gli utenti UK assegnano in media punteggi leggermente più elevati.
Lo score medio dei recensori britannici è pari a (8,49), contro (8,31) per il gruppo delle altre nazionalità, suggerendo una maggiore tendenza nel pubblicare 
recensioni positive provenienti dal gruppo UK.*/
________________________________________________________________________________________________________________________________________________________

/*Hotel con maggior Average_Score e numero recensioni*/
SELECT
    h.hotel_name,
    hs.average_score,
    hs.total_number_of_reviews
FROM hotel_stats hs
JOIN hotels h
    ON hs.hotel_id = h.hotel_id
ORDER BY hs.average_score DESC, hs.total_number_of_reviews DESC;
________________________________________________________________________________________________________________________________________________________
/*L’analisi degli hotel con maggiore Average_Score e numero totale di recensioni permette di individuare le strutture con le migliori performance complessive.
Ordinando i risultati prima per punteggio medio e poi per numero di recensioni, è possibile distinguere gli hotel che presentano valutazioni elevate e, allo 
stesso tempo, un volume consistente di recensioni. Questo rende il risultato più affidabile, perché un punteggio alto supportato da molte recensioni è più 
rappresentativo rispetto a uno score elevato basato su poche osservazioni.*/
________________________________________________________________________________________________________________________________________________________

/*Analisi gap tra Reviewer_Score e Average Score*/
SELECT

    h.hotel_name,

    ROUND(AVG(r.reviewer_score), 2) AS media_reviewer_score,

    hs.average_score,

    ROUND(AVG(r.reviewer_score) - hs.average_score, 2) AS gap_score

FROM reviews r

JOIN hotels h

    ON r.hotel_id = h.hotel_id

JOIN hotel_stats hs

    ON r.hotel_id = hs.hotel_id

GROUP BY h.hotel_id, h.hotel_name, hs.average_score

ORDER BY gap_score DESC;
________________________________________________________________________________________________________________________________________________________
/*L’analisi del gap tra Reviewer_Score medio e Average_Score evidenzia differenze tra la valutazione media calcolata dalle recensioni presenti nel database
e il punteggio medio registrato per ciascun hotel. In diversi casi il gap è positivo, indicando che i recensori inclusi nel dataset assegnano punteggi medi 
superiori rispetto all’Average_Score dell’hotel.*/
________________________________________________________________________________________________________________________________________________________

/*Distribuzione recensioni per città*/
SELECT

    CASE

        WHEN h.hotel_address LIKE '%London%' THEN 'London'

        WHEN h.hotel_address LIKE '%Paris%' THEN 'Paris'

        WHEN h.hotel_address LIKE '%Barcelona%' THEN 'Barcelona'

        WHEN h.hotel_address LIKE '%Amsterdam%' THEN 'Amsterdam'

        WHEN h.hotel_address LIKE '%Vienna%' THEN 'Vienna'

        WHEN h.hotel_address LIKE '%Milan%' THEN 'Milan'

        ELSE 'Altra citta'

    END AS city,

    COUNT(r.review_id) AS numero_recensioni

FROM reviews r

JOIN hotels h

    ON r.hotel_id = h.hotel_id

GROUP BY city

ORDER BY numero_recensioni DESC;
_________________________________________________________________________________________________________________________________________________________
/*La distribuzione delle recensioni per città evidenzia una netta prevalenza di Londra con 262.298 recensioni, che concentra la quota maggiore del totale delle recensioni. Seguono
Barcellona, Parigi e Amsterdam con valori molto inferiori ma tra loro relativamente simili. Milano e Vienna presentano invece i volumi più contenuti del dataset.*/
_________________________________________________________________________________________________________________________________________________________

/*Score medio per nazione*/
SELECT
    CASE
        WHEN h.hotel_address LIKE '%United Kingdom%' THEN 'United Kingdom'
        WHEN h.hotel_address LIKE '%France%' THEN 'France'
        WHEN h.hotel_address LIKE '%Spain%' THEN 'Spain'
        WHEN h.hotel_address LIKE '%Netherlands%' THEN 'Netherlands'
        WHEN h.hotel_address LIKE '%Austria%' THEN 'Austria'
        WHEN h.hotel_address LIKE '%Italy%' THEN 'Italy'
        ELSE 'Altro'
    END AS country,
    ROUND(AVG(r.reviewer_score), 2) AS score_medio,
    COUNT(r.review_id) AS numero_recensioni
FROM reviews r
JOIN hotels h
    ON r.hotel_id = h.hotel_id
GROUP BY country
ORDER BY score_medio DESC;


_________________________________________________________________________________________________________________________________________________________
/*L’analisi geografica per nazione mostra che l’Austria presenta il punteggio medio più elevato, seguita da Spagna e Paesi Bassi. Il Regno Unito registra invece
lo score medio più basso tra i paesi considerati, pur concentrando il numero più alto di recensioni nel dataset. Lo score medio per nazione è stato calcolato raggruppando
le recensioni in base al paese in cui si trova l’hotel, ricavato dal campo hotel_address. I risultati mostrano differenze tra i paesi del dataset in termini di valutazione
media assegnata dagli utenti.*/
_________________________________________________________________________________________________________________________________________________________

/*score medio top città*/
SELECT

    CASE

        WHEN h.hotel_address LIKE '%London%' THEN 'London'

        WHEN h.hotel_address LIKE '%Paris%' THEN 'Paris'

        WHEN h.hotel_address LIKE '%Barcelona%' THEN 'Barcelona'

        WHEN h.hotel_address LIKE '%Amsterdam%' THEN 'Amsterdam'

        WHEN h.hotel_address LIKE '%Vienna%' THEN 'Vienna'

        WHEN h.hotel_address LIKE '%Milan%' THEN 'Milan'

        ELSE 'Altra citta'

    END AS city,

    ROUND(AVG(r.reviewer_score), 2) AS score_medio,

    COUNT(r.review_id) AS numero_recensioni

FROM reviews r

JOIN hotels h

    ON r.hotel_id = h.hotel_id

GROUP BY city

ORDER BY score_medio DESC;
_________________________________________________________________________________________________________________________________________________________

/*L’analisi dello score medio per città evidenzia che Vienna registra il punteggio medio più elevato, seguita da Barcellona e Amsterdam. Londra presenta 
invece il punteggio medio più basso, pur concentrando il volume più elevato di recensioni nel dataset.*/
_________________________________________________________________________________________________________________________________________________________

/*Distribuzione Review_Length per categoria score*/
SELECT

    CASE

        WHEN reviewer_score < 5 THEN 'Basso'

        WHEN reviewer_score < 8 THEN 'Medio'

        ELSE 'Alto'

    END AS categoria_score,

    COUNT(*) AS numero_recensioni,

    ROUND(AVG(total_review_length), 2) AS lunghezza_media,

    MIN(total_review_length) AS lunghezza_min,

    MAX(total_review_length) AS lunghezza_max

FROM reviews

GROUP BY categoria_score;
_________________________________________________________________________________________________________________________________________________________
/*L’analisi della lunghezza delle recensioni per categoria di score evidenzia che le recensioni con punteggio basso sono mediamente più lunghe rispetto a 
quelle con punteggio alto. Questo suggerisce che gli utenti insoddisfatti tendano a fornire commenti più dettagliati, mentre le recensioni più positive 
risultano mediamente più sintetiche.*/
_________________________________________________________________________________________________________________________________________________________

/*Correlazione lunghezza recensione vs Reviewer_Score*/
SELECT

    reviewer_score,

    ROUND(AVG(total_review_length), 2) AS lunghezza_media

FROM reviews

GROUP BY reviewer_score

ORDER BY reviewer_score;
_________________________________________________________________________________________________________________________________________________________
/*A differenza dell’analisi per categorie, in questo caso l’obiettivo è osservare il rapporto diretto tra due variabili numeriche, verificando se recensioni
più lunghe sono associate a punteggi mediamente più alti o più bassi.L’analisi della relazione tra Reviewer_Score e lunghezza media della recensione mostra 
che i punteggi più bassi tendono ad associarsi a testi più lunghi. Questo suggerisce che gli utenti insoddisfatti siano più propensi a descrivere in dettaglio 
l’esperienza negativa, mentre i giudizi più positivi risultano
mediamente più sintetici.*/
_________________________________________________________________________________________________________________________________________________________