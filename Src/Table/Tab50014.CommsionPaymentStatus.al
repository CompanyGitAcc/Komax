table 50014 "Commsion Payment Status"
{

    fields
    {
        field(1; "Sales Inv. No."; Code[20])
        {
        }
        field(5; "Sales Person Code"; Code[20])
        {
        }
        field(10; Commision; Decimal)
        {
        }
        field(15; "Payment Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Sales Inv. No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

