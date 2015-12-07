with Ada.Unchecked_Deallocation;
with Ada.Text_IO; use Ada.Text_IO;

package body Liste_Generique is

   type Cellule is record
      Val: Element;
      Suiv: Liste;
   end record;

   type Iterateur_Interne is record
      Adresse: Liste;
      Suivant: Liste;
   end record;
   ----------------------------------------------------------

   procedure Liberer_Cellule is new Ada.Unchecked_Deallocation (Cellule, Liste);
   procedure Liberer_Iterateur is new Ada.Unchecked_Deallocation (Iterateur_Interne, Iterateur);

   ---------------------------------------------------------

   -- Affichage de la liste, dans l'ordre de parcours
   procedure Affiche_Liste (L : in Liste) is
      Curseur: Liste;
   begin
      Curseur:=L;
      while Curseur/=null loop
         Put(Curseur.Val);
         New_Line;
         Curseur:=Curseur.Suiv;
      end loop;
   end Affiche_Liste;

    -- Insertion d'un element V en tete de liste
   procedure Insere_Tete (V : in Element; L : in out Liste) is
      N: Liste;
   begin
      N:=new Cellule'(V,L);
      L:=N;
   end Insere_Tete;

 -- Vide la liste et libere toute la memoire utilisee
   procedure Libere_Liste(L : in out Liste) is
      Curseur, Tmp: Liste;
   begin
      Curseur:=L;
      while Curseur/=null loop
         Tmp:=Curseur.Suiv;
         Liberer_Cellule(Curseur);
         Curseur:=Tmp;
      end loop;
   end Libere_Liste;

    -- Creation de la liste vide
   function Creer_Liste return Liste is
   begin
      return null;
   end Creer_Liste;

    -- Cree un nouvel iterateur 
   function Creer_Iterateur (L : Liste) return Iterateur is
   begin
      if L/=null then return new Iterateur_Interne'(null,L);
      else return null;
      end if;
   end Creer_Iterateur;

    -- Liberation d'un iterateur
   procedure Libere_Iterateur(It : in out Iterateur) is
   begin
      Liberer_Iterateur(It);
   end Libere_Iterateur;

    -- Avance d'une case dans la liste
   procedure Suivant(It : in out Iterateur) is
   begin
      if A_Suivant(It) then
         It.Adresse:=It.Suivant;
         It.Suivant:=It.Adresse.Suiv;
      else
         raise FinDeListe;
      end if;
   end Suivant;

   -- Retourne l'element courant
   function Element_Courant(It : Iterateur) return Element is
   begin
      if It/=null then
         if It.Adresse/=null then
            return It.Adresse.Val;
         else
            if A_Suivant(It) then
               raise IT_Passe_Au_Suivant;
            else
               raise FinDeListe;
            end if;
         end if;
      else
         raise FinDeListe;
      end if;
   end Element_Courant;

   -- Verifie s'il reste un element a parcourir
   function A_Suivant(It : Iterateur) return Boolean is
   begin
      if It.Suivant/=null then return true;
      else return false;
      end if;
   end A_Suivant;

end Liste_Generique;

