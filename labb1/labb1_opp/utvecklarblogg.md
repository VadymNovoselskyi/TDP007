# Utvecklarblogg seminarium 1

Det har gått relativt bra att lära sig Ruby hittills. Vi har främst använt dokumentationen, sökt information via Google samt diskuterat med andra klasskamrater.

Ett mindre problem som verkar återkomma i flera kurser är att programmeringsspråk utvecklas snabbt, medan många svar på internet, särskilt från StackOverflow, är gamla och ibland utdaterade. I Rubys fall verkar det mesta fortfarande fungera, men vi har märkt att framför allt konventioner ofta har modernare alternativ. Vi använder till exempel vanliga parenteser för behållare eftersom det är så lösningar i sökresultat ofta ser ut, men i nyare artiklar framgår det att detta eventuellt är ett föråldrat arbetssätt.

Eftersom vi kommer direkt från C++ märks det tydligt hur mycket mer förlåtande Ruby är, samt att det finns flera sätt att skriva samma kod. Detta gäller särskilt användningen av parenteser och mellanslag. Det kan vara skönt eftersom spontan kod ofta fungerar ungefär som man tänkt sig, men också frustrerande när man inte riktigt förstår varför något fungerar eller om det kan uppstå sidoeffekter längre fram.

Vi har tyvärr knappt använt några nya tekniker. Uppgiften saknade specifika krav på arbetssätt och hade en relativt tight deadline, så vi bedömde att grundläggande metoder räckte för att få fram något spelbart. Förhoppningen är att lära oss mer under seminariet.

Något som däremot var nytt för oss var unit testing, vilket påminner om Catch från C++ men känns betydligt enklare och mer intuitivt. Vi ser fram emot att lära oss mer om hur verktyget kan användas och appliceras i framtida projekt.

Uppgiften i övrigt innebar inga större konstigheter. Vi har implementerat Sokoban tidigare i Python och hade redan de flesta verktyg vi behövde. Vi valde en imperativ lösning helt utan klasser eftersom vi fortfarande är ovana vid Ruby och eftersom uppgiften inte specificerade mer avancerade metoder. En intressant observation är hur mycket snabbare arbetet gick jämfört med motsvarande laboration i en tidigare kurs, trots att vi i princip använde samma metod. Kraven var något slappare och spelet inte lika komplett, men det kändes ändå tydligt att det gick snabbare den här gången, även med ett nytt språk.

Under det första passet diskuterade vi vilken lösning som skulle passa bäst. Klasser är sannolikt det ”bästa” sättet att lösa uppgiften på, men eftersom spelet i grunden är ett rutnät av symboler i terminalen som uppdateras efter användarinput valde vi att läsa in en level-fil till en global board-variabel. Denna modifierades sedan efter behov och input.

Hela implementationen skedde över ett par efterföljande pass. Slutligen skapade vi testfilen och skrev utvecklarbloggen. Enligt instruktionerna borde testfilen ha skapats tidigare och byggts ut löpande, samt att utvecklarbloggen skrivits parallellt med kodandet. På grund av omständigheter blev det dock inte så den här gången.




