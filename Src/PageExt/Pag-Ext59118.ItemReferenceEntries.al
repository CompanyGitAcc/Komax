pageextension 59118 "TP Item Reference Entries" extends "Item Reference Entries"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        addfirst(Control1)
        {
            field("Item No."; Rec."Item No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }
    }

}
