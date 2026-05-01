import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/'

  if (code) {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error && data.user) {
      // Sauvegarder le username depuis les métadonnées si pas encore en base
      const username = data.user.user_metadata?.username as string | undefined
      if (username) {
        const { data: existing } = await supabase
          .from('profiles')
          .select('username')
          .eq('id', data.user.id)
          .maybeSingle()

        if (!existing?.username) {
          await supabase
            .from('profiles')
            .upsert({ id: data.user.id, username }, { onConflict: 'id' })
        }
      }

      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(
    `${origin}/login?error=${encodeURIComponent('Lien de confirmation invalide ou expiré.')}`,
  )
}
