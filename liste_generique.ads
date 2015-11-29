-- liste_generique.ads
---------------------------------------------------------------

--   La partie GENERIQUE du package:
--   1. le type Element des elements de la liste
--   2. une procedure "Put" affichant un element
--

generic
    type Element is private;
    with procedure Put(E : in Element);
    
-- Les specifications du package, qui n'utilisent
-- que les elements et procedures generiques
package Liste_Generique is
    type Liste is private;
    type Iterateur is private;
    -- Affichage de la liste, dans l'ordre de parcours
    procedure Affiche_Liste (L : in Liste);
    -- Insertion d'un element V en tete de liste
    procedure Insere_Tete (V : in Element; L : in out Liste);
    -- Vide la liste et libere toute la memoire utilisee
    procedure Libere_Liste(L : in out Liste);
    -- Creation de la liste vide
    function Creer_Liste return Liste;
    -- Cree un nouvel iterateur 
    function Creer_Iterateur (L : Liste) return Iterateur;
    -- Liberation d'un iterateur
    procedure Libere_Iterateur(It : in out Iterateur);
    -- Avance d'une case dans la liste
    procedure Suivant(It : in out Iterateur);
    -- Retourne l'element courant
    function Element_Courant(It : Iterateur) return Element;
    -- Verifie s'il reste un element a parcourir
    function A_Suivant(It : Iterateur) return Boolean;

   FinDeListe : exception;
   IT_Passe_Au_Suivant: exception;

private 
    type Cellule;
    type Liste is access Cellule;

    type Iterateur_Interne;
    type Iterateur is access Iterateur_Interne;
   
end Liste_Generique;


