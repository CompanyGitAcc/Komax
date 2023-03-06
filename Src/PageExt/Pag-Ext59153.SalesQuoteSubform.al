pageextension 59153 "TP Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }

        addafter("Location Code")
        {
            field("Inventory"; Rec."Inventory")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }

        moveafter("Item Reference No."; Quantity)
        moveafter(Quantity; "Unit Price")
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }
    }


}
