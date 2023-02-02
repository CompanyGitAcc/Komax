tableextension 59064 "TP Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        // field(50000; "Jinsui Invoice No."; Code[20])
        // {
        //     Caption = 'Jinsui Invoice No.';
        // }
        //++Deposit
        field(60001; "Order No."; Code[100])
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
        field(60003; "JinShui Inv. No."; Code[100])
        {
            Caption = 'JinShui Inv. No.';
            DataClassification = ToBeClassified;
        }
        field(60004; "Customer Name 2"; Text[50])
        {
            Caption = 'Customer Name 2';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Name 2" WHERE("No." = FIELD("Customer No.")));
        }
    }
}
