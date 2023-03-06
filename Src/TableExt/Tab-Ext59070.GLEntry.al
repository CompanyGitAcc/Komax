tableextension 59070 "TP G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; Any; Integer)
        {
            Caption = 'Any';
        }
        field(50001; "Value Entry Exist"; Boolean)
        {
            Caption = 'Value Entry Exist';
            FieldClass = FlowField;
            CalcFormula = exist("Value Entry" where("Document No." = field("Document No."), "Posting Date" = field("Posting Date")));
        }
        field(50002; "Customer Entry Exist"; Boolean)
        {
            Caption = 'Customer Entry Exist';
            FieldClass = FlowField;
            CalcFormula = exist("Cust. Ledger Entry" where("Document No." = field("Document No."), "Posting Date" = field("Posting Date")));
        }
    }

}
