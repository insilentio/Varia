library(ggplot2)


# finde alle Primzahlen in einem bestimmten Bereich
# von 1 bis upper

# definiere oberes Limit
upper <- 1e6

# Variante 1, nicht sehr effizient ###################################
# fange mit der kleinsten ungeraden Primzahl an (technische Gründe)
# und wiederhole für jede natürliche Zahl bis upper
primes <- c(3)  
for (i in seq(3, upper)) {
  # dividiere die Zahl durch alle bereits bekannten Primzahlen
  # und speichere den Rest
  rest <- i %% primes
  
  # prüfe, ob der Rest irgendwo 0 ist -> keine Primzahl
  # falls immer ein Rest entstand, haben wir eine neue PZ
  # und fügen sie der Liste der bestehenden hinzu
  if (0 %in% rest) {
    next
  } else primes <- c(primes, i)
}
# zum Schluss muss noch 2 der Liste vorangestellt werden
primes <- c(2, primes)


# Variante 2: ca. 1e5x schneller ######################################
# wir arbeiten hier nicht die ganze Liste ab, sondern schmeissen
#  bei jeder gefundenen PZ alle Vielfachen davon aus der Liste raus.
#  Somit sind in der Liste automatisch nur noch PZ

# wir starten schon mal nur mit einer Liste der ungeraden Zahlen (sowie 2)
primes <- c(2, seq.int(3, upper, by = 2))
j <- 3
i <- primes[j]

# wir müssen nicht die ganze Liste abarbeiten: sobald wir bei der
# Quadratwurzel des oberen Limits angekommen sind, können wir aufhören
while ((i^2) <= upper) {
  # für eine gefundene Zahl erstellen wir eine temporäre Liste aller
  # doppelten Vielfachen, beginnend beim Quadrat der Zahl. Grund:
  # Bis zur Quadratzahl sind die Vielfachen sicher schon aussortiert.
  # Zudem müssen wir dann nur jede 2. Vielfache prüfen, da die anderen
  # ja gerade wären und somit eh keine PZ.
  # Dann vergleichen wir diese temporäre Liste mit unserer Gesamtliste
  # und schmeissen aus der Gesamtliste die Übereinstimmungen raus
  
  primes <- primes[! primes %in% seq.int(i^2, upper, by = 2*i)]

  # dann arbeiten wir mit der neuen, reduzierten Gesamtliste weiter.
  # die nächste Zahl hierdrin ist bereits wieder eine PZ
  j <- j + 1
  i <- primes[j]
}


# Zum Schluss plotten wir die gefundenen PZ in einer Häufigkeitsverteilung
ggplot(data.frame(x = primes)) +
  aes(x = x) +
  geom_histogram(binwidth = 1e4, fill = "lightgray") +
  scale_x_continuous(limits = c(0, upper),
                     breaks = seq(0, upper, by = upper/5)) +
  labs(y ="# PZ pro 10'000") +
  theme_light()
  