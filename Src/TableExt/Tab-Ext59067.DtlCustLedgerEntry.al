tableextension 59067 "TP Detailed Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        // field(50000; "Jinsui Invoice No."; Code[20])
        // {
        //     Caption = 'Jinsui Invoice No.';
        // }
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
