tableextension 59068 "TP Detailed Vendor Ledg. Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        //++Deposit
        field(60001; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            DataClassification = ToBeClassified;
            //TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Sales Order No."));
        }
        field(60002; "Advance Payment"; Boolean)
        {
            Caption = 'Advance Payment';
            DataClassification = ToBeClassified;
        }
        //--Deposit        
    }
}
