tableextension 59079 "TP General Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        // field(50000; "Voucher - Manager"; Text[30])
        // {
        //     Caption = 'Voucher - Manager';
        // }
        // field(50001; "Voucher - Checked By"; Text[30])
        // {
        //     Caption = 'Voucher - Checked By';
        // }
        // field(50002; "Golden Tax - Issuer"; Text[60])
        // {
        //     Caption = 'Golden Tax - Issuer';
        // }
        // field(50003; "Golden Tax - Checked by"; Text[30])
        // {
        //     Caption = 'Golden Tax - Checked by';
        // }
        field(50004; "Hide Blocked COA"; Boolean)
        {
            Caption = 'Hide Blocked COA';
        }
    }

}
