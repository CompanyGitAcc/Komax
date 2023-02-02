tableextension 59073 "TP Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Vendor Name"; Text[80])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor."Name 2" WHERE("No." = FIELD("Account No.")));
        }
        field(50001; "Customer Name"; Text[80])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."Name 2" WHERE("No." = FIELD("Account No.")));
        }
        //++Deposit
        field(60001; "Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
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
