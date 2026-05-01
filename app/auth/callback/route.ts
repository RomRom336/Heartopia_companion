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
      const username = data.user.user_metadata?.username as string | undefined
      if (username) {
        // Upsert inconditionnel : le trigger a créé la ligne avec username=null
        await supabase
          .from('profiles')
          .upsert({ id: data.user.id, username }, { onConflict: 'id' })
        // Sync avec le Display name Supabase (visible dans le dashboard)
        await supabase.auth.updateUser({ data: { full_name: username } })
      }

      return NextResponse.redirect(`${origin}${next}`)
    }
  }

  return NextResponse.redirect(
    `${origin}/login?error=${encodeURIComponent('Lien de confirmation invalide ou expiré.')}`,
  )
}
