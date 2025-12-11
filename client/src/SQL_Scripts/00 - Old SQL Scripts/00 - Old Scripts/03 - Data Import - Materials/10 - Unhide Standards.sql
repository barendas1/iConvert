Update StandardInfo
    Set IsActive = 1
From dbo.StandardInfo As StandardInfo
Inner Join dbo.Static_Standard As Standard
On StandardInfo.StandardID = Standard.Static_StandardID
Inner Join dbo.Static_StandardsOrganization As Organization
On Organization.Static_StandardsOrganizationID = Standard.Static_StandardsOrganizationID
Where Organization.Static_StandardsOrganizationID In (34, 35, 36)

Update StandardsOrgInfo
    Set IsActive = 1
From dbo.StandardsOrgInfo As StandardsOrgInfo
Inner Join dbo.Static_StandardsOrganization As Organization
On StandardsOrgInfo.StandardsOrgID = Organization.Static_StandardsOrganizationID
Where Organization.Static_StandardsOrganizationID In (34, 35, 36)
