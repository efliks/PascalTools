
{ Program stosuje procedury numeryczne dla wielomianow zdefiniowanych
    przez uzytkownika.

    Ostatnie zmiany : 05.01.2004.
}

program fxx;

{ $APPTYPE CONSOLE}

{ uses
  SysUtils;}

const
    EKSTR_ROSNIE = 1;
    EKSTR_MALEJE = 2;
    EKSTR_STALY = 3;

    { maksymalny stopien wielomianu }
    MAX_STOPIEN = 10;

type
    ekran = array[1..25, 1..80] of char;
    
    { dodaj takze miejsce na wyraz wolny }
    wsp_tab = array[1..(MAX_STOPIEN + 1)] of real;

var
    { dane okreslajace wielomian : stopien wielomianu i jego wspolczynniki }
    stopien, ile_wspolcz : integer;
    wspolczynniki : wsp_tab;

    xp, xk, delta_x, t, nowe_dx : real;
    opcja : byte;
    koniec_proga : boolean;
    m_zer : real;
    ob : integer;

    { Ta zmienna mowi, czy moja_funkcja jest wielomianem zdefiniowanym
    przez uzytkownika. Jesli jest_wielomian = TRUE, to mozna stosowac
    operacje analityczne. Zmienna zadeklarowana na wypadek, gdyby
    w nastepnych wersjach programu byla mozliwosc uzycia nie tylko
    wielomianow, ale takze innych funkcji. W tej wersji programu
    jest_wielomian zawsze wynosi TRUE. }
    jest_wielomian : boolean;

{----------------------------------------------------------------------}

function symbol_wspolcz(i : integer) : char;
begin
    symbol_wspolcz := (chr((i - 1) + ord('a')));
end;

{----------------------------------------------------------------------}

{ argument "zdef" ekresla czy uzytkownik podal juz wspolczynniki
    wielomianu, czy nalezy zastosowac symbole literowe }
procedure drukuj_wzor_wielomianu(zdef : boolean);
var
    i, potega : integer;
    w : real;
begin
    write('f(x) = ');

    for i := 1 to ile_wspolcz do
        begin
            potega := ile_wspolcz - i;
            w := wspolczynniki[i];

            if zdef = false then
                begin
                    if i <> 1 then write(' + ');

                    write(symbol_wspolcz(i));

                    if potega > 0 then write(' * ');
                end
            else
                begin
                    if (w = 0.0) and (ile_wspolcz > 1) then continue;

                    if w < 0.0 then
                        write(' - ')
                    else if i <> 1 then
                        write(' + ');

                    w := abs(w);

                    if potega > 0 then 
                        begin
                            if w <> 1.0 then
                                write(w : 4 : 4, ' * ');
                        end
                    else
                        write(w : 4 : 4);
                end;

            if potega > 1 then
                write('x^', potega)
            else if potega = 1 then
                write('x');
        end;
end;

{----------------------------------------------------------------------}

procedure definiuj_wielomian;
var
    i, ss : integer;
    w : real;
    ok : boolean;
begin
    ss := stopien; { zachowaj stary stopien }

    write('Podaj stopien wielomianu (0 - ', MAX_STOPIEN, ') : ');
    readln(stopien);

    if (stopien < 0) or (stopien > MAX_STOPIEN) then
        begin
            writeln('Podano nieprawidlowy stopien !');
            writeln('Nacisnij ENTER...'); readln;

            { przywroc stary stopien bo nowy jest nieprawidlowy }
            stopien := ss
        end
    else
        begin
            for i := 1 to (MAX_STOPIEN + 1) do wspolczynniki[i] := 0.0;

            ile_wspolcz := stopien + 1;

            write('Wielomian ma postac : ');
            drukuj_wzor_wielomianu(false);
            writeln;

            repeat
                for i := 1 to ile_wspolcz do
                    begin
                        write('Podaj ', symbol_wspolcz(i), ' : ');
                        readln(w);

                        if (ile_wspolcz > 1) and (i = 1) and (w = 0.0) then
                            begin
                                ok := false;
                                writeln('Blad ! Pierwszy wspolczynnik musi byc rozny od 0 !');
                                break;
                            end
                        else
                            begin
                                wspolczynniki[i] := w;
                                ok := true;
                            end;
                    end;
            until ok = true;
        end;

    jest_wielomian := true;
end;

{----------------------------------------------------------------------}

function do_potegi(x : real; n : integer) : real;
var
    i : integer;
    r : real;
begin
    r := 1.0;
    for i := 1 to abs(n) do r := r * x;

    if n < 0 then r := 1.0 / r;

    do_potegi := r;
end;

{----------------------------------------------------------------------}

function moja_funkcja(x : real) : real;
var
    r : real;
    i : integer;
begin
    r := 0;
    for i := 1 to ile_wspolcz do
        r := r + (wspolczynniki[i] * do_potegi(x, ile_wspolcz - i));

    moja_funkcja := r;
end;

{----------------------------------------------------------------------}

{ calka : metoda trapezow }
function calka_trapezy(x1, x2, delta : real) : real;
var
    n, i : integer;
    r, a, b : real;
begin
    { obliczamy ilosc przedzialow = ilosc trapezow }
    n := round((x2 - x1) / delta);

    r := 0;
    a := x1;
    b := x1 + delta;

    for i := 1 to n do
        begin
            { sumujemy pola trapezow }
            r := r + ((moja_funkcja(a) + moja_funkcja(b)) * delta / 2.0);

            { nastepny trapez }
            a := b;
            b := b + delta;
        end;

    calka_trapezy := r;
end;

{----------------------------------------------------------------------}

{ calka : metoda prostokatow }
function calka_prostokaty(x1, x2, delta : real) : real;
var
    n, i : integer;
    r, a : real;
begin
    { obliczamy ilosc prostokatow }
    n := round((x2 - x1) / delta);

    a := x1;
    r := 0.0;

    for i := 1 to n do
        begin
            { wysokosc prostokata jest wartoscia funkcji W SRODKU
            aktualnego przedzialu }
            r := r + (delta * moja_funkcja(a + (delta / 2.0)));

            { nastepny prostokat }
            a := a + delta;
        end;

    calka_prostokaty := r;
end;

{----------------------------------------------------------------------}

{ calka : metoda prosta Simpsona }
function calka_simpson(x1, x2, delta : real) : real;
var
    i, n : integer;
    r, a, b, c : real;
begin
    { dzielimy przedzial x1..x2 na parzysta ilosc podprzedzialow }
    n := round(((x2 - x1) / (2.0 * delta)));

    a := x1;
    b := a + delta;
    c := b + delta;

    r := 0.0;

    { sumujemy pola pod parabolami w kazdym przedziale }
    for i := 1 to n do
        begin
            { pole paraboli ze wzoru Simpsona :
                P = delta / 3 * (f1 + 4 * f2 + f3) }
            r := r + (delta / 3.0 * (moja_funkcja(a) + 4.0 * moja_funkcja(b) +
                moja_funkcja(c)));

            { nastepny przedzial }
            a := c;
            b := a + delta;
            c := b + delta;
        end;

    calka_simpson := r;
end;

{----------------------------------------------------------------------}

{ liczy najmniejsza wartosc funkcji na przedziale }
function wartosc_najmniejsza(x1, x2, delta : real) : real;
var
    r, t : real;
begin
    r := moja_funkcja(x1);
    x1 := x1 + delta;

    repeat
        t := moja_funkcja(x1);
        if t < r then r := t;

        x1 := x1 + delta;
    until x1 > x2;

    wartosc_najmniejsza := r;
end;

{----------------------------------------------------------------------}

{ liczy najwieksza wartosc funkcji na przedziale }
function wartosc_najwieksza(x1, x2, delta : real) : real;
var
    r, t : real;
begin
    r := moja_funkcja(x1);
    x1 := x1 + delta;

    repeat
        t := moja_funkcja(x1);
        if t > r then r := t;
        
        x1 := x1 + delta;
    until x1 > x2;

    wartosc_najwieksza := r;
end;

{----------------------------------------------------------------------}

{ wlasna metoda znajdywania miejsc zerowych }
procedure m_zerowe_moja(x1, x2, d : real);
var
    fx, xa, xb, x0 : real;
    t : boolean;
    ile_miejsc : integer;
begin
    t := false;
    ile_miejsc := 0;

    { przejdz po calym przedziale <x1,x2> }
    repeat
        fx := moja_funkcja(x1);

        { znaleziono przedzial, w ktorym przyblizenie jest wystarczajace }
        if abs(fx) < d then
            begin
                if t = false then
                    begin
                        { tu zaczyna sie otoczenie miejsca
                        zerowego }
                        t := true;
                        xa := x1;
                    end;
            end
        else
            begin
                if t = true then
                    begin
                        { koniec otoczenia miejsca zerowego }
                        t := false;

                        xb := x1;
                        ile_miejsc := ile_miejsc + 1;

                        { przyblizenie : miejsce zerowe wypada
                        mniej wiecej na srodku otoczenia }
                        x0 := (xa + xb) / 2.0;

                        writeln('x0(', ile_miejsc, ') = ', x0 : 8 : 8);
                    end;
            end;
        
        x1 := x1 + d;
    until x1 > x2;

    if ile_miejsc = 0 then writeln('nie znaleziono miejsc zerowych !')
end;

{----------------------------------------------------------------------}

function m_zerowe_falsi(x1, x2, d : real;
    var x_zero : real; var obiegi : integer) : boolean;
var
    x0, xa, xb : real;
    jest_m : boolean;
    i : integer;
begin
    xa := x1;
    xb := x2;
    jest_m := false;
    i := 0;

    repeat
        i := i + 1;
        if i = 30000 then break; { zabezpieczenie przed zawieszeniem }

        { sprawdz, czy przedzial spelnia zalozenie }
        if ((moja_funkcja(xa) * moja_funkcja(xb)) > 0.0) then
            break;

        { poprowadz sieczna przez punkty (xa, f(xa)) i (xb, f(xb)) oraz
        wyznacz punkt x0 czyli przeciecie siecznej z osia ox }
        x0 := xa - (moja_funkcja(xa) * (xb - xa) / (moja_funkcja(xb) -
            moja_funkcja(xa)));
        
        { zdecyduj czy x0 dostatecznie dobrze aproksymuje prawdziwe
        miejsce zerowe }
        if abs(moja_funkcja(x0)) < d then
            begin
                jest_m := true;
                x_zero := x0;
                break;
            end
        else
            begin
                if ((moja_funkcja(xa) * moja_funkcja(x0)) < 0.0) then
                    xb := x0
                else
                    xa := x0;
            end;
    until 1 <> 1;

    obiegi := i;
    m_zerowe_falsi := jest_m;
end;

{----------------------------------------------------------------------}

{ szuka miejsca zerowego algorytmem bisekcji (polowienia) }
function m_zerowe_bisekcja(x1, x2, d : real;
    var x0 : real; var obiegi : integer) : boolean;
var    
    i : integer; { liczy ilosc obiegow zanim odnaleziono miejsce zerowe }
    c : real;
    r : boolean;
begin
    r := false;
    i := 0;

    repeat
        i := i + 1;
        if i = 30000 then break;

        { sprawdz warunek f(x1) * f(x2) < 0, co oznacza, ze
        wykres funkcji przecina os ox na tym przedziale }
        if ((moja_funkcja(x1) * moja_funkcja(x2)) > 0.0) then
            break;

        { podziel badany przedzial na dwie polowy }
        c := (x1 + x2) / 2.0;

        { sprawdz, czy osiagnieto wystarczajace przyblizenie }
        if (abs(moja_funkcja(c)) < d) then
            begin
                x0 := c;
                r := true;
                break;
            end;

        { wybierz ten podprzedzial, w ktorym wykres przecina os ox }
        if ((moja_funkcja(x1) * moja_funkcja(c)) < 0.0) then
            x2 := c
        else
            x1 := c;
    until 1 <> 1; { petla nieskonczona przerywana wewnatrz }

    m_zerowe_bisekcja := r;
    obiegi := i;
end;

{----------------------------------------------------------------------}

procedure ekstrema_lokalne(x1, x2, d : real);
var
    poprz_y, nowe_y, x : real;
    poprz_t, nowe_t : byte;
    i, ile_max, ile_min : integer;
begin
    poprz_y := moja_funkcja(x1);
    x1 := x1 + d;
    i := 0;
    ile_max := 0;
    ile_min := 0;

    { analizuje funkcje krok po kroku przechodzac przez caly przedzial }
    repeat
        i := i + 1;

        nowe_y := moja_funkcja(x1);

        if nowe_y > poprz_y then
            nowe_t := EKSTR_ROSNIE
        else if nowe_y < poprz_y then
            nowe_t := EKSTR_MALEJE
        else
            nowe_t := EKSTR_STALY;

        if i > 1 then { nie wyciagaj jeszcze wnioskow, najpierw inicjuj dane }
            begin
                x := x1 - (d / 2.0);

                if nowe_t <> poprz_t then { pierwsza pochodna zmienila znak }
                    begin
                        if (poprz_t = EKSTR_ROSNIE) and
                        (nowe_t = EKSTR_MALEJE) then { jest maksimum wlasciwe }
                            begin
                                ile_max := ile_max + 1;
                                write('MAX wlasciwe w punkcie (');
                            end
                        else if (poprz_t = EKSTR_ROSNIE) and
                        (nowe_t = EKSTR_STALY) then { jest maksimum niewlasciwe }
                            begin
                                ile_max := ile_max + 1;
                                write('MAX niewlasciwe w punkcie (');
                            end
                        else if (poprz_t = EKSTR_MALEJE) and
                        (nowe_t = EKSTR_ROSNIE) then { jest minimum wlasciwe }
                            begin
                                ile_min := ile_min + 1;
                                write('MIN wlasciwe w punkcie (');
                            end
                        else { jest minimum niewlasciwe }
                            begin
                                ile_min := ile_min + 1;
                                write('MIN niewlasciwe w punkcie (');
                            end;

                        writeln(x : 8 : 8, ', ', moja_funkcja(x) : 8 : 8, ')');
                    end;
            end;

        poprz_y := nowe_y;
        poprz_t := nowe_t;

        x1 := x1 + d;
    until x1 > x2;

    if (ile_max = 0) and (ile_min = 0) then
        writeln('nie znaleziono ekstremow lokalnych !')
    else
        begin
            writeln('Znaleziono minimow : ', ile_min);
            writeln('Znaleziono maksimow : ', ile_max);
        end;
end;

{----------------------------------------------------------------------}

function pochodna_z_definicji(x, epsilon : real) : real;
begin
    pochodna_z_definicji := (moja_funkcja(x + epsilon) - moja_funkcja(x)) / epsilon;
end;

{----------------------------------------------------------------------}

function pochodna_analitycznie(x : real) : real;
var
    i, p, nowa_pot : integer;
    s, nowy_wsp : real;
begin
    s := 0.0;

    for i := 1 to ile_wspolcz do
        begin
            if wspolczynniki[i] = 0.0 then continue;

            p := ile_wspolcz - i;
	    if p = 0 then break;
            
            nowy_wsp := wspolczynniki[i] * p;
            nowa_pot := p - 1;

            s := s + (nowy_wsp * do_potegi(x, nowa_pot));
        end;
    
    pochodna_analitycznie := s;
end;

{----------------------------------------------------------------------}

function calka_analitycznie(x1, x2 : real) : real;
var
    i, p, nowa_p : integer;
    s, xx : real;
begin
    s := 0.0;

    for i := 1 to ile_wspolcz do
        begin
            if wspolczynniki[i] = 0.0 then continue;

            p := ile_wspolcz - i;

            nowa_p := p + 1;

            xx := (do_potegi(x2, nowa_p) -
                do_potegi(x1, nowa_p)) / nowa_p;
            s := s + wspolczynniki[i] * xx;    
        end;
    
    
    calka_analitycznie := s;
end;

{----------------------------------------------------------------------}

procedure menu;
begin                        
    write('        oo                             oo                                       ');
    write('       oooo                           ooo                                       ');
    write('      o                                oo                    oo                 ');
    write('      o                                oo                    o                  ');
    write('     oooo      o    o      o   o       oo  o         oo       o        oo       ');
    write('    oooo     ooo   oo    ooo  oo       oo ooo       oooo    ooo       oooo      ');
    write('      oo      oo  ooo     oo oooo      oo  o       o  o      oo      o  o       ');
    write('      oo      oo  ooo     ooo  oo      oo o       oo         oo     oo o        ');
    write('      oo      oo o oo     oo   oo      ooooo      ooo        oo     oo          ');
    write('      oo      ooo  oo     oo   oo      oo  oo      ooo       oo      ooo o      ');
    write('      o        o   o      o    o       o   ooo      oooo     oo       ooo       ');
    write('                                                             oo                 ');
    write('------------------------------[ (c) 2004 Mickey Mouse ]------oo-----------------');
    write('                                                             oo                 ');

    write('Funkcja : ');
        drukuj_wzor_wielomianu(true);
    writeln;

    writeln('Przedzial : xp = ', xp : 4 : 4, ', xk = ', xk : 4 : 4);
    writeln('Epsilon (dokladnosc obliczen) = ', delta_x : 4 : 4);
    writeln;

    writeln('( 1) zdefiniuj funkcje                ( 2) podaj przedzial dziedziny');
    writeln('( 3) podaj epsilon                    ( 4) oblicz calke');
    writeln('( 5) oblicz pochodna w punkcie xp     ( 6) oblicz ekstrema lokalne');
    writeln('( 7) oblicz miejsce zerowe funkcji    ( 8) rysuj orientacyjny wykres funkcji');
    writeln('( 9) wartosc najmniejsza i najwieksza (10) koniec');
    writeln;

    write('>');
end;

{----------------------------------------------------------------------}

procedure rysuj_wykres(x1, x2, d : real);
var
    i, j, f : integer;
    e : ekran;
    min, max, wys, szer, wspolcz, delta, h : real;

begin
    { wyczysc bufor ekranowy }
    for i :=1 to 24 do
        for j := 1 to 80 do e[i, j] := ' ';

    min := wartosc_najmniejsza(x1, x2, d);
    max := wartosc_najwieksza(x1, x2, d);

    wys := abs(max - min);
    szer := x2 - x1;

    { wspolczynnik, ktory skaluje wykres funkcji do rozmiarow ekranu }
        wspolcz := wys / 24.0;

    delta := szer / 80.0;

    { funkcja jest stala, unikaj dzielenia przez 0 }
    if wspolcz = 0.0 then wspolcz := 1.0;

    for i := 1 to 80 do
        begin
            f := round((moja_funkcja(x1) - min) / wspolcz);

            e[24 - f, i] := 'o';
            x1 := x1 + delta;
        end;

    { kopiuj z bufora na ekran }
    for i := 1 to 24 do
        for j := 1 to 80 do write(e[i, j]);

    write('Nacisnij ENTER...'); readln;
end;

{----------------------------------------------------------------------}

begin
    { ustawienia domyslne }
    jest_wielomian := true; { wszystkie funkcje w tym programie sa wielomianami }
    delta_x := 0.001;
    xp := 0.0;
    xk := 1.0;
    stopien := 1;
    ile_wspolcz := 2;
    wspolczynniki[1] := 1.0;
    wspolczynniki[2] := 0.0;
    
    
    koniec_proga := false;

    repeat
        menu;

        readln(opcja);

        if opcja = 1 then
                definiuj_wielomian
        else if opcja = 2 then
            begin
                write('Podaj xp : ');
                readln(xp);
                write('Podaj xk : ');
                readln(xk);

                if xp > xk then
                    begin
                        t := xp;
                        xp := xk;
                        xk := t;
                    end;
            end
        else if opcja = 3 then
            begin
                write('Podaj epsilon : ');
                readln(nowe_dx);
                if nowe_dx <= 0.0 then
                    begin
                        writeln('Blad ! Epsilon musi byc wiekszy od zera !');
                        write('Nacisnij ENTER...'); readln;
                    end
                else
                    delta_x := nowe_dx;
            end
        else if opcja = 4 then
            begin
                writeln('CALKA...');
                writeln('metoda prostokatow = ',
                    calka_prostokaty(xp, xk, delta_x) : 8 : 8);
                writeln('metoda trapezow = ',
                    calka_trapezy(xp, xk, delta_x) : 8 : 8);
                writeln('metoda Simpsona = ',
                    calka_simpson(xp, xk, delta_x) : 8 : 8);

                if jest_wielomian = true then
                    writeln('metoda analityczna = ',
                        calka_analitycznie(xp, xk) : 8 : 8);

                write('Nacisnij ENTER...'); readln;
            end
        else if opcja = 5 then
            begin
                writeln('POCHODNA W PUNKCIE XP...');
                writeln('numerycznie : f`(xp) = ',
                    pochodna_z_definicji(xp, delta_x) : 8 : 8);
                
                if jest_wielomian = true then
                    writeln('analitycznie : f`(xp) = ',
                        pochodna_analitycznie(xp) : 8 : 8);

                write('Nacisnij ENTER...'); readln;
            end
        else if opcja = 6 then
            begin
                write('Ekstrema : '); ekstrema_lokalne(xp, xk, delta_x);
                write('Nacisnij ENTER...'); readln;
            end
        else if opcja = 7 then
            begin
                writeln('MIEJSCE ZEROWE...');

                write('metoda polowienia (bisekcji) : ');
                if (m_zerowe_bisekcja(xp - delta_x, xk + delta_x, delta_x, m_zer, ob) = true) then
                    writeln('x0 = ', m_zer : 8 : 8, ' (ilosc obiegow : ', ob, ')')
                else
                    writeln('nie znaleziono miejsca zerowego !');

                write('metoda siecznych (falsi) : ');
                if (m_zerowe_falsi(xp - delta_x, xk + delta_x, delta_x, m_zer, ob) = true) then
                    writeln('x0 = ', m_zer : 8 : 8, ' (ilosc obiegow : ', ob, ')')
                else
                    writeln('nie znaleziono miejsca zerowego !');

                write('moja metoda : '); m_zerowe_moja(xp - delta_x, xk + delta_x, delta_x);

                write('Nacisnij ENTER...'); readln;
            end
        else if opcja = 8 then
            rysuj_wykres(xp, xk, delta_x)
        else if opcja = 9 then
            begin
                writeln('Wartosc najmniejsza na przedziale : xmin = ',
                    wartosc_najmniejsza(xp, xk, delta_x) : 8 : 8);
                writeln('Wartosc najwieksza na przedziale : xmax = ',
                    wartosc_najwieksza(xp, xk, delta_x) : 8 : 8);
                write('Nacisnij ENTER...'); readln;
            end
        else if opcja = 10 then
            begin
                writeln('Koniec programu.');
                koniec_proga := true;
            end;

    until koniec_proga = true;
end.
