import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/theme-provider'
import { AuthProvider } from '@/components/auth-provider'
import { Navbar } from '@/components/navbar'
import { createClient } from '@/utils/supabase/server'

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-sans',
  display: 'swap',
})

export const metadata: Metadata = {
  title: {
    default: 'Heartopia Companion - Tracker & Cuisine',
    template: '%s | Heartopia Companion',
  },
  description:
    "L'outil ultime pour optimiser votre progression dans Heartopia.",
  openGraph: {
    title: 'Heartopia Companion - Tracker & Cuisine',
    description: "L'outil ultime pour optimiser votre progression dans Heartopia.",
    type: 'website',
  },
}

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  // Hydrate l'auth côté serveur pour éviter le flash "non connecté"
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  return (
    <html lang="fr" className={inter.variable} suppressHydrationWarning>
      <body className="min-h-screen bg-background font-sans text-foreground antialiased">
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <AuthProvider initialUser={user}>
            <Navbar />
            {children}
          </AuthProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}
