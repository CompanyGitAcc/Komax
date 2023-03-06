pageextension 59152 "TP Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(Location)
        {
            field("Default Custom Location"; Rec."Default Custom Location")
            {
                ApplicationArea = all;
            }
        }

        modify("Nonstock Item Nos.")
        {
            Visible = true;
            Importance = Additional;
        }
        moveafter("Item Nos."; "Nonstock Item Nos.")

    }


}
