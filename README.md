# Hodnocení projektu

## Přehled bodů

| Číslo projektu | Hodnocení | Maximální počet bodů |
|----------------|-----------|----------------------|
| 1.             | 19        | 23                   |

## Odevzdané (validní) soubory

- **cpu.vhd:** ano
- **login.b:** ano
- **inp.png:** ano
- **inp.srp:** ano

## Ověření činnosti kódu CPU

| #  | Testovaný program (kód)      | Výsledek |
|----|------------------------------|----------|
| 1. | ++++++++++                   | ok       |
| 2. | ----------                   | ok       |
| 3. | +>++>+++                     | ok       |
| 4. | <+<++<+++                    | ok       |
| 5. | .+.+.+.                      | ok       |
| 6. | ,+,+,+,                      | chyba    |
| 7. | [........]noLCD[.........]   | ok       |
| 8. | +++[.-]                      | ok       |
| 9. | +++++[>++[>+.<-]<-]          | ok       |
| 10.| +[+~.------------]+          | ok       |

- **Podpora jednoduchých cyklů:** ano
- **Podpora vnořených cyklů:** ano

## Poznámky k implementaci

- Kód po syntéze nepracuje korektně.
- Data z klávesnice jsou korektně načtena, ale chybně zapsána do RAM (zpoždění jeden takt).

**Celkem bodů za CPU implementaci:** 13 (z 17)
