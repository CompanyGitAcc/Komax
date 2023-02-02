tableextension 59092 "TP Warehouse Activity Line" extends "Warehouse Activity Line"
{
    fields
    {
        field(50000; "Pre-Receipt Bin Code"; Code[20])
        {
            Caption = 'Pre-Receipt Bin Code';
            TableRelation = Bin.Code;
        }
        field(50001; "QR Code"; Blob)
        {
            Caption = 'QR Code';
            Subtype = Bitmap;
        }
        field(50002; "Trolley No."; Code[20])
        {
            Caption = 'Trolley No.';
        }
    }

    keys
    {
        key(Key20; "Trolley No.")
        {
        }
    }

}
