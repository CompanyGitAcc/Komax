pageextension 59137 "TP Warehouse Activity List" extends "Warehouse Activity List"
{
    layout
    {
        addlast(Control1)
        {
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = all;
            }
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = all;
            }
            field("Customr No."; Rec."Customr No.")
            {
                ApplicationArea = all;
            }
            field("Put-away Bin Code"; Rec."Put-away Bin Code")
            {
                ApplicationArea = all;
            }
            field("Create Date"; Rec."Create Date")
            {
                ApplicationArea = all;
            }
            field("Document Status"; Rec."Document Status")
            {
                ApplicationArea = all;
            }

        }
    }

}
