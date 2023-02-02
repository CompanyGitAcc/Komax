pageextension 59007 "TP User Setup" extends "User Setup"
{
    layout
    {
        addafter("User ID")
        {
            field("User Name"; Rec."User Name")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Batch Rel. Or Del. Docs."; Rec."Batch Rel. Or Del. Docs.")
            { ApplicationArea = all; }

            field(Cashier; Rec.Cashier)
            {
                ApplicationArea = all;
            }
            field("Finance Controller"; Rec."Finance Controller")
            {
                ApplicationArea = all;
            }
            //==============================================================================
            //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
            //==============================================================================              
            // field("Can Edit Credit Limit"; Rec."Can Edit Credit Limit")
            // {
            //     ApplicationArea = all;
            // }
            // field("HR Module Operator"; Rec."HR Module Operator")
            // {
            //     ApplicationArea = all;
            // }
            // field("Allow Invoice On Order"; Rec."Allow Invoice On Order")
            // {
            //     ApplicationArea = all;
            // }
            // field("User Name"; Rec."User Name")
            // {
            //     ApplicationArea = all;
            // }
            // field("Allow Change Vendor Block"; Rec."Allow Change Vendor Block")
            // {
            //     ApplicationArea = all;
            // }
            // field("Price Permission"; Rec."Price Permission")
            // {
            //     ApplicationArea = all;
            // }
            // field("Block Vendor"; Rec."Block Vendor")
            // {
            //     ApplicationArea = all;
            // }
        }
    }
}
