with Participant;
use Participant;

generic
   Largeur, Hauteur, Nb_alignes: Integer;
package Puissance4 is
   type Vecteur2 is array(1..2) of Integer;
   type Coup is record
      Coordonnees: Vecteur2;
      Qui: Joueur;
   end record;
   type Grille is array(Positive range 1..Largeur,Positive range 1..Hauteur) of Integer range 0..2;
   type Etat is record
      G: access Grille;
      dernier_coup: Coup;
   end record;
   type Element is record
      Situation : Etat;
      Pere : access Element;
      Fgauche: access Element;
      Fdroit: access Element;
      Evaluation : Integer;
   end record;

   -- Calcule l'etat suivant en appliquant le coup
   function Jouer(E : Etat; C : Coup) return Etat;
   -- Indique si l'etat courant est gagnant pour le joueur J
   function Est_Gagnant(E : in Etat; Jo : in Joueur) return Boolean;
   --fonction permettant de connaitre le nombre de jeton aligné pour un joueur donné à partir d'une position donnée
   function Alignement(G: access Grille; I: Integer; J: Integer; SI: Integer; SJ: Integer; Compteur: Integer) return Boolean;
   -- Indique si l'etat courant est un status quo (match nul)
   function Est_Nul(E : Etat) return Boolean;
   -- Fonction d'affichage de l'etat courant du jeu
   procedure Afficher(E : Etat);
   -- Affiche a l'ecran le coup passe en parametre
   procedure Affiche_Coup(C : in Coup);
   -- Retourne le prochaine coup joue par le joueur1
   function Demande_Coup_Joueur1(E : Etat) return Coup;
   -- Retourne le prochaine coup joue par le joueur2
   function Demande_Coup_Joueur2(E : Etat) return Coup;

   procedure Initialiser(E: in out Etat);
   procedure Put(E: in Element);



end Puissance4;
