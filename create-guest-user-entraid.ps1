# Verifica se o módulo AzureAD está instalado
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    Write-Host "Instalando o módulo AzureAD..."
    Install-Module -Name AzureAD -Force -Scope CurrentUser
}

# Importa o módulo AzureAD
Import-Module AzureAD

# Autentica no Azure AD
Write-Host "Conectando ao Azure AD..."
Connect-AzureAD

# Lista de usuários externos para adicionar
$externalUsers = @(
    @{
        Email = "usuarioexterno1@dominioexterno.com";
        DisplayName = "Usuário Externo 1";
    },
    @{
        Email = "usuarioexterno2@dominioexterno.com";
        DisplayName = "Usuário Externo 2";
    }
)

# URL de redirecionamento após o aceite do convite
$inviteRedirectUrl = "https://myapplications.microsoft.com"

# Loop para criar os usuários externos
foreach ($user in $externalUsers) {
    try {
        Write-Host "Enviando convite para $($user.Email)..."
        $invitation = New-AzureADMSInvitation -InvitedUserEmailAddress $user.Email `
                                               -InvitedUserDisplayName $user.DisplayName `
                                               -InviteRedirectUrl $inviteRedirectUrl `
                                               -SendInvitationMessage $true
        Write-Host "Convite enviado com sucesso para: $($user.Email)"
    } catch {
        Write-Host "Erro ao enviar convite para $($user.Email): $_" -ForegroundColor Red
    }
}

Write-Host "Processo concluído!"
