import { createBrowserClient } from '@supabase/ssr'

/**
 * Client Supabase pour Client Components (navigateur).
 * Gère automatiquement la lecture/écriture des cookies de session.
 */
export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  )
}
