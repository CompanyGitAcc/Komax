table 50035 "PPI With Vendor"
{
    // DrillDownPageID = "Customer Sales Buffer";
    // LookupPageID = "Customer Sales Buffer";

    fields
    {
        field(1; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; Currency; Code[20])
        {
            Caption = 'Currency';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; Year; Code[20])
        {
            Caption = 'Year';
        }
        field(6; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }


}

