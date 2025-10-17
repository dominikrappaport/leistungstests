# Leistungsdaten und Analyse

## Autor

Dominik Rappaport, dominik@rappaport.at

## Hintergrund

Ich bin Hobbyradsportler und trainiere seit einigen Jahren „ernsthaft“. Davon
abgesehen habe ich ein Faible für Statistik und Auswertungen (mein Mathematik-Studium
muss ja für etwas gut gewesen sein 😂).

Ich lade Daten aus verschiedenen Quellen:

1. Garmin (Gewicht, Herzfrequenz, Bodybattery, Herzfrequenzvariabilität und Ruhepuls)
2. TrainingPeaks bzw. WKO5 (CTL, ATL, TSS, TSB, Trainingsdauer und Gesundheitszustand)
3. Komplette Ranglisten bestimmter Stravasegmente (heruntergeladen mit einem selbstentwickeltem 
Programm, dem [SegmentDownloader](https://github.com/dominikrappaport/SegmentDownloader))
4. Aufzeichnugnen gemacht mit dem [Tymewear VitalPro strap](https://www.tymewear.com/).
5. Rohdaten meiner Labortests (Sprioergometrie), gemacht bei [HPC St. Pölten](https://www.h-p-c.at/).

## Daten

Die diversen Datenquelle liegen im CSV-Format vor und sind mit selbsterklärenden
Namen abgelegt unter
[https://github.com/dominikrappaport/leistungstests/tree/main/data/processed](https://github.com/dominikrappaport/leistungstests/tree/main/data/processed) 
und ggf. weiteren Unterverzeichnissen.

## Auswertung

In den meisten Fällen erstelle ich Diagramme mittels der [GGPlot2-Bibliothek](https://ggplot2.tidyverse.org/) 
in der Programmiersprache [R](https://www.r-project.org/). Zusätzlich findet
sich eine Zusammenfassung als RMarkdown-Datei.

1. [Trainingsstatistik](https://github.com/dominikrappaport/leistungstests/blob/main/docs/trainingload.md) - Quellcode:
[https://github.com/dominikrappaport/leistungstests/blob/main/docs/trainingload.Rmd](https://github.com/dominikrappaport/leistungstests/blob/main/docs/trainingload.Rmd)
2. [Gewichtsverlauf](https://github.com/dominikrappaport/leistungstests/blob/main/docs/weight.md) - Quellcode: 
[https://github.com/dominikrappaport/leistungstests/blob/main/docs/weight.Rmd](https://github.com/dominikrappaport/leistungstests/blob/main/docs/weight.Rmd)
3. [Analyse zum Anstieg auf den Jauerling](https://dominik-rappaport.shinyapps.io/FallstudieJauerling/) (mein Lieblingsanstieg), interkativ mit Hilfe von [https://shiny.posit.co/](https://shiny.posit.co/). Quellcode: [https://github.com/dominikrappaport/leistungstests/tree/main/shiny](https://github.com/dominikrappaport/leistungstests/tree/main/shiny)
4. Diverse weitere Auswertungen im Ordner [src](https://github.com/dominikrappaport/leistungstests/tree/main/src). Die Ausgabe erfolgt dabei immer in den Ordner [output](https://github.com/dominikrappaport/leistungstests/tree/main/output)

## Schlussatz

Ich teile diese Daten sowie die entsprechenden Skripts um andere Menschen
Beispiele zu geben, die eventuell ähnliches vorhaben. Mir selbst ist es eine
Motivation und ein Anlass, mich mit neuen Bibliotheken (wie z. B. Shiny) zu 
beschäftigen.