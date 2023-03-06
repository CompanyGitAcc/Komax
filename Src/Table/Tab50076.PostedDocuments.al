table 50036 "Posted Documents"
{
    Caption = 'Posted Documents';

    fields
    {
        field(1; "Document Type"; Enum "Item Ledger Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Date Filter"; date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(4; "Cost Amount(Expected)"; Decimal)
        {
            Caption = 'Cost Amount(Expected)';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Expected)" where("Posting Date" = field("Date Filter"),
                                                                            "Document No." = field("Document No."),
                                                                            "Item No." = filter(<> '')));
        }
        field(5; "Cost Amount(Actual)"; Decimal)
        {
            Caption = 'Cost Amount(Actual)';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Posting Date" = field("Date Filter"),
                                                                            "Document No." = field("Document No."),
                                                                            "Item No." = filter(<> '')));
        }
        field(6; "GL-Inventory"; Decimal)
        {
            Caption = 'GL-Inventory';
            FieldClass = FlowField;
            CalcFormula = sum("G/L Entry".Amount where("Posting Date" = field("Date Filter"),
                                                                "G/L Account No." = field("Inventory Account Filter"),
                                                                "Document No." = field("Document No.")));
        }
        field(7; "Inventory Account Filter"; text[200])
        {
            Caption = 'Inventory Account Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }


    fieldgroups
    {
    }
    var
        Diff: Decimal;
}

