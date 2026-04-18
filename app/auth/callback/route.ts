import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

/**
 * Callback de confirmation e-mail et OAuth.
 * Supabase redirige ici après clic sur le lien de vérification ;
 * on échange le code contre une session puis on renvoie l'utilisateur
 * sur la destination souhaitée (par défaut : accueil).
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    if (!error) {
      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(
    `${origin}/login?error=${encodeURIComponent('Lien de confirmation invalide ou expiré.')}`,
  )
}
