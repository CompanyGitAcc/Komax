tableextension 59065 "TP Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        //++Deposit
        field(60001; "Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order), "No." = FIELD("Order No."));
        }
        field(60002; "Advance Payment"; Boolean)
        {
            Caption = 'Advance Payment';
            DataClassification = ToBeClassified;
        }
        //--Deposit        
    }
}
