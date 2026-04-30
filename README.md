# Hotel Reviews Analysis Project

Progetto di analisi end-to-end sul dataset *Hotel_Reviews.csv* di Booking.com preso da Kaggle.
Il lavoro integra Python, pandas, SQL, Matplotlib e MariaDB/phpMyAdmin per la pulizia dei dati, creazione di un database relazionale, analisi di query e produzione di grafici e report finale.

---

## 1. Obiettivo del progetto

L'obiettivo del progetto è analizzare recensioni reali sugli hotel europei, individuando elementi utili per comprendere:

- andamento temporale delle recensioni;
- nazionalità dei recensori più presenti nel dataset;
- differenze tra recensori UK e altre nazionalità;
- performance di hotel e città;
- relazione tra lunghezza della recensione e punteggio assegnato;
- possibili insight utili per un Revenue Manager.

Il progetto segue il flusso:

1. pulizia del dataset con Python e pandas;
2. salvataggio del dataset pulito;
3. creazione dello schema SQL;
4. popolamento delle tabelle;
5. analisi tramite query SQL;
6. analisi e grafici con pandas e Matplotlib;
7. redazione del report finale.

---

## 2. Dataset utilizzato

Dataset originale:

Hotel_Reviews.csv

Il dataset contiene recensioni di hotel europei estratte da Booking.com e include, tra le altre, le seguenti informazioni:

- nome e indirizzo dell'hotel;
- data della recensione;
- nazionalità del recensore;
- recensione positiva e negativa;
- conteggio parole positive e negative;
- punteggio assegnato dal recensore;
- punteggio medio dell'hotel;
- numero totale di recensioni ricevute dall'hotel;
- tag del soggiorno;
- latitudine e longitudine dell'hotel.

Dopo la fase di pulizia è stato generato il file:

hotel_reviews_clean.csv

Questo file rappresenta il dataset pulito utilizzato per il caricamento SQL e per le analisi successive.

---

## 3. Struttura del progetto

La struttura richiesta dalle istruzioni è:

PROJECT/
├── DATASET.CSV
├── 01_EDA_CLEANING.IPYNB
├── 02_ANALYSIS_PANDAS_PLOTS.IPYNB
├── CREATE_TABLES.SQL
├── INSERT DATA.SQL
├── ANALYSIS_QUERIES.SQL
├── FINAL_REPORT.PDF
└── README.MD

Nota: nelle istruzioni è indicato INSERT DATA.SQL; nel progetto il caricamento dei dati è stato svolto tramite notebook Python (INSERT DATA 2.ipynb) usando pandas e SQLAlchemy. La funzione del file resta la stessa, quella di popolare il database SQL con i dati puliti.

---

## 4. Prerequisiti

Per eseguire il progetto sono necessari:

- Python;
- Jupyter Notebook oppure JupyterLab;
- pandas;
- numpy;
- matplotlib;
- SQLAlchemy;
- driver di connessione a MariaDB/MySQL;
- MariaDB o MySQL;
- phpMyAdmin, se si vuole gestire il database da interfaccia grafica.

Librerie Python principali:

python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sqlalchemy import create_engine


---

## 5. Ordine corretto di apertura ed esecuzione dei file

Per riprodurre correttamente il progetto, i file devono essere aperti ed eseguiti in questo ordine.
---

### 5.1 Primo file: 01_EDA_CLEANING 3.IPYNB

Questo è il primo notebook da aprire.

In questo file viene svolta la fase di preparazione e pulizia del dataset originale.

Operazioni principali:

1. importazione delle librerie Python;
2. caricamento del dataset originale Hotel_Reviews.csv;
3. creazione di una copia del dataframe;
4. esplorazione iniziale del dataset;
5. controllo di dimensioni, colonne e tipi di dato;
6. controllo dei valori mancanti;
7. controllo ed eliminazione dei duplicati esatti;
8. conversione della colonna Review_Date in formato data;
9. creazione delle colonne review_year e review_month;
10. creazione di variabili derivate, tra cui la lunghezza totale della recensione;
11. salvataggio del dataset pulito.

Output prodotto:

hotel_reviews_clean.csv

Questo file viene usato nei passaggi successivi per il database SQL e per l'analisi con pandas.

---

### 5.2 Secondo file: CREATE_TABLE.SQL

Dopo aver creato il dataset pulito, si apre il file SQL per creare lo schema del database.

Il file crea quattro tabelle principali:

#### hotels

Contiene le informazioni anagrafiche degli hotel:

- hotel_id;
- hotel_name;
- hotel_address;
- lat;
- lng.

#### reviewers

Contiene le informazioni sui recensori:

- reviewer_id;
- reviewer_nationality;
- total_number_of_reviews_reviewer_has_given.

#### hotel_stats

Contiene le statistiche associate agli hotel:

- hotel_id;
- average_score;
- total_number_of_reviews;
- additional_number_of_scoring.

#### reviews

Contiene le recensioni:

- review_id;
- hotel_id;
- reviewer_id;
- review_date;
- review_year;
- review_month;
- reviewer_score;
- negative_review;
- positive_review;
- review_total_negative_word_counts;
- review_total_positive_word_counts;
- tags;
- days_since_review;
- stay_nights;
- total_review_length.

Le tabelle sono collegate tramite chiavi primarie e chiavi esterne:

- hotel_stats.hotel_id fa riferimento a hotels.hotel_id;
- reviews.hotel_id fa riferimento a hotels.hotel_id;
- reviews.reviewer_id fa riferimento a reviewers.reviewer_id.

---

### 5.3 Terzo file: INSERT_DATA.ipynb

Dopo aver creato le tabelle, si apre il notebook dedicato al caricamento dei dati nel database. Per questo è stata creata une pipeline di caricamento dati su SQL.

Questo file usa il dataset pulito:

hotel_reviews_clean.csv

Operazioni principali:

1. importazione del dataset pulito con pandas;
2. connessione al database MariaDB/MySQL tramite SQLAlchemy;
3. preparazione del dataframe per la tabella hotels;
4. preparazione del dataframe per la tabella reviewers;
5. preparazione del dataframe per la tabella hotel_stats;
6. preparazione del dataframe per la tabella reviews;
7. recupero degli identificativi hotel_id e reviewer_id;
8. creazione della colonna review_id;
9. caricamento dei dati nelle tabelle SQL con to_sql();
10. verifica del corretto popolamento delle tabelle.

Questo passaggio permette di trasformare il dataset pulito in un database relazionale organizzato.

---

### 5.4 Quarto file: ANALYSIS_QUERIES.SQL

Dopo il caricamento dei dati, si apre il file delle query SQL.

Il file contiene query di controllo e query di analisi.

#### Verifiche iniziali

Sono state eseguite query per controllare:

- numero di righe nella tabella hotels;
- numero di righe nella tabella hotel_stats;
- numero di righe nella tabella reviewers;
- numero di righe nella tabella reviews;
- correttezza della join tra hotels e reviews;
- distribuzione dei punteggi per nazionalità.

#### Analisi SQL principali

Le query sono organizzate secondo le aree richieste:

1. andamento delle recensioni per anno e mese;
2. hotel con picco di recensioni;
3. top 10 nazionalità per numero di recensioni e score medio;
4. percentuale di contributo delle principali nazionalità;
5. confronto tra recensori UK e altre nazionalità;
6. hotel con migliore average_score e numero di recensioni;
7. gap tra reviewer_score e average_score;
8. distribuzione delle recensioni per città;
9. score medio per città;
10. lunghezza delle recensioni e relazione con il punteggio.

Questo file risponde alle principali domande di business del progetto.

---

### 5.5 Quinto file: 02_ANALYSIS_PANDAS_PLOTS.IPYNB

Dopo l'analisi SQL, si apre il notebook dedicato all'analisi con pandas e alla produzione dei grafici.

In questo file vengono riprodotte e approfondite le analisi principali già svolte con SQL.

Operazioni principali:

1. caricamento del dataset pulito;
2. analisi dell'andamento temporale delle recensioni;
3. analisi delle nazionalità dei recensori;
4. analisi delle città e degli hotel;
5. analisi della lunghezza delle recensioni;
6. confronto tra punteggi e variabili numeriche;
7. produzione dei grafici con Matplotlib.

Grafici richiesti dal progetto:

1. line plot delle recensioni per mese e anno;
2. bar chart delle top 10 nazionalità per numero di recensioni;
3. bar chart delle top 10 città per numero di recensioni;
4. box plot della distribuzione del Reviewer Score per le top 3 nazionalità;
5. istogramma della lunghezza delle recensioni per categoria di score;
6. scatter plot tra lunghezza recensione e Reviewer Score;
7. bar chart dello score medio per le top 10 città;
8. heatmap delle correlazioni numeriche.

I grafici sono stati usati come supporto per il report finale.

---

### 5.6 Sesto file: FINAL_REPORT.PDF

Il report finale è l'ultimo file da consultare.

Contiene la sintesi del progetto e segue questa struttura:

1. introduzione al dataset Booking.com;
2. metodologia: pulizia, SQL, pandas e visualizzazioni;
3. risultati principali;
4. trend temporali delle recensioni;
5. profilo delle nazionalità dei recensori;
6. performance di città e hotel;
7. correlazione tra score e lunghezza delle recensioni;
8. conclusioni con insight per Revenue Manager.
   
N.B Ho voluto aggiungere inoltre una parte dedicata agli eventuali limiti incontrati durante l'analisi che potrebbero aiutare ad avere una visione più consapevole dell'analisi effettiva rapportandolo alla data odierna.

---

## 6. Setup del database

Per riprodurre la parte SQL:

1. creare un database vuoto in MariaDB/MySQL;
2. aprire CREATE_TABLE.SQL in phpMyAdmin o in un client SQL;
3. eseguire lo script per creare le tabelle;
4. aprire INSERT DATA 2.ipynb;
5. modificare la stringa di connessione al database, se necessario;
6. eseguire il notebook per popolare le tabelle;
7. aprire ANALYSIS_QUERIES.SQL;
8. eseguire le query di verifica e analisi.


---
## 7. Come riprodurre l'intero progetto

Sequenza completa:

1. scaricare il dataset originale Hotel_Reviews.csv;
2. aprire 01_EDA_CLEANING 3.IPYNB;
3. eseguire tutte le celle per generare hotel_reviews_clean.csv;
4. creare il database in MariaDB/MySQL;
5. eseguire CREATE_TABLE.SQL;
6. aprire INSERT_DATA.ipynb;
7. eseguire il caricamento dei dati nelle tabelle;
8. eseguire le query contenute in ANALYSIS_QUERIES.SQL;
9. aprire 02_ANALYSIS_PANDAS_PLOTS.IPYNB;
10. generare le analisi pandas e i grafici Matplotlib;
11. consultare FINAL_REPORT.PDF per la sintesi conclusiva.

---

## 8. Output finali

Gli output principali del progetto sono:

- dataset pulito hotel_reviews_clean.csv;
- database SQL con tabelle relazionate;
- query SQL di analisi;
- analisi pandas;
- grafici Matplotlib;
- report finale in PDF;
- repository GitHub organizzato secondo la struttura richiesta.

---

## 9. Note finali

Il progetto dimostra un flusso completo di lavoro data analysis:

- dalla pulizia del dato grezzo;
- alla normalizzazione in tabelle SQL;
- all'analisi tramite query;
- alla visualizzazione tramite Python;
- alla presentazione dei risultati in un report finale.

La struttura dei file segue le istruzioni del progetto, mantenendo l'ordine logico necessario per riprodurre correttamente l'intera analisi.
