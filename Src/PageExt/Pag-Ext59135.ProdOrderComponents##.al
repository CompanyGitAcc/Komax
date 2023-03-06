pageextension 59135 "TP Prod. Order Components" extends "Prod. Order Components"
{
    layout
    {
        addlast(Control1)
        {
            field("Scrap Quantity"; Rec."Scrap Quantity")
            {
                ApplicationArea = all;
            }
            field(Stock; Rec.Stock)
            {
                ApplicationArea = all;
            }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = all;
            }
            field("Rout Link"; Rec."Rout Link")
            {
                ApplicationArea = all;
            }
            field("Gen Prod Posting Group"; Rec."Gen Prod Posting Group")
            {
                ApplicationArea = all;
            }
        }
        addfirst(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }

        modify("Qty. Picked")
        {
            Visible = true;
            Editable = true;
        }
        moveafter("Item No."; "Quantity per")
        modify("Location Code")
        {
            Visible = true;
        }
        moveafter("Quantity per"; "Location Code")
    }

}
